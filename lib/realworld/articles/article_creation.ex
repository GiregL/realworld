defmodule Realworld.Articles.ArticleCreation do
  @moduledoc """
  Article creation functions.
  """

  alias Realworld.Articles.Article
  alias Realworld.Articles.TagArticle
  alias Realworld.Articles.Tag
  alias Realworld.Repo

  @doc """
  Creates an article from the given parameters.

  Returns an Article instance which can be inserted in the database.
  """
  @spec create_article_from_params(Map.t()) :: {:ok, Article.t()} | {:error, String.t()}
  def create_article_from_params(%{"title" => title, "body" => body, "description" => description} = params) do
    article = %Article{
      title: title,
      body: body,
      description: description,
      slug: create_slug_from_title(title)
    }

    # Optional fields
    update_article = fn article, field ->
      if Map.has_key?(params, field) do
        Map.put(article, String.to_atom(field), Map.get(params, field))
      else
        article
      end
    end

    article = update_article.(article, "tagList")
    article = update_article.(article, "author")

    {:ok, article}
  end

  def create_article_from_params(_params) do
    {:error, "Required parameters: title, body, description."}
  end

  @spec create_slug_from_title(String.t()) :: String.t()
  def create_slug_from_title(title) do
    title
    |> String.trim()
    |> String.split()
    |> Enum.map(fn x -> String.downcase(x) end)
    |> Enum.map(fn word ->
        word
        |> String.to_charlist()
        |> Enum.filter(fn chr ->
          (chr >= ?a and chr <= ?z) or (chr >= ?A and chr <= ?Z) or (chr >= ?0 and chr <= ?9)
        end)
        |> to_string()
      end)
    |> Enum.filter(fn x -> String.length(String.trim(x)) != 0 end)
    |> Enum.join("-")
  end

  @doc """
  Insert the given article into the database, using Ecto Schema
  """
  @spec insert_article_in_database(Article.t()) :: {:ok, Article.t()} | {:error, String.t()}
  def insert_article_in_database(%Article{} = article) do
    case Repo.insert(article) do
      {:ok, article} -> {:ok, article}
      {:error, _} -> {:error, "Failed to insert article."}
    end
  end

  @doc """
  Inserts the tags of the given article into the database.
  """
  @spec insert_article_tags(Article.t(), list(String.t())) :: :ok | {:error, String.t()}
  def insert_article_tags(%Article{id: nil}, _), do: {:error, "This article does not exists in the database. No ID found."}
  def insert_article_tags(%Article{} = article, tagList) do
    article_id = article.id

    #
    # Adding all the tags to the new article
    taglist_insertions = tagList
    |> Enum.map(fn tag ->
      # Adding the tags
      tag_id = Repo.get_by(Tag, title: tag)

      if is_nil(tag_id) do
        {:error, "Tag: " <> tag <> " does not exists."}
      else
        case Repo.insert(%TagArticle{tag: tag_id.id, article: article_id}) do
          {:ok, _} -> :ok
          {:error, _} -> {:error, "Failed to add tag " <> tag <> " to article " <> article_id}
        end
      end
    end)

    success = taglist_insertions
    |> Enum.all?(fn x ->
      # Checking if all tags are added
      case x do
        :ok -> true
        {:error, message} ->
          IO.puts message
          false
      end
    end)

    # If a insertion fail occured
    if success do
      :ok
    else
      {:error, "Failed to insert all tags into the database."}
    end
  end
end
