defmodule RealworldWeb.ArticlesController do
  use RealworldWeb, :controller

  @moduledoc """
  Article controller
  """

  alias Realworld.{Repo, Articles.Article, Articles.TagArticle, Realworld.Tag}
  import Ecto.Query
  import Realworld.Articles.ArticleCreation

  @doc """
  Returns the list of all articles from the database

  Accepted parameters:
  - author
  - limit
  - offset (needs limit)
  - tag
  """
  def article_list(conn, params) do
    limit = Map.get(params, "limit", 20)
    offset = Map.get(params, "offset", 0)

    result = cond do
      Map.has_key?(params, "author") -> Repo.get_by(Article, [author: Map.get(params, "author")])

      Map.has_key?(params, "tag") ->
        tag_id = Repo.get_by(Tag, title: Map.get(params, "tag"))
        if is_nil(tag_id) do
          []
        else
          articles_id = Repo.all(from ta in TagArticle, where: ta.tag == ^(tag_id.id), select: ta.article)

          Repo.all(
            from a in Article, [
              where: a.id in ^articles_id,
              limit: ^limit,
              offset: ^offset
          ])
        end

      true -> Repo.all(from a in Article, limit: ^limit, offset: ^offset)
    end

    json conn, %{ "articles" => result }
  end

  @doc """
  Returns a list of articles:
  - Made by the followed users
  - The most recent first
  """
  def article_feed(conn, params) do
    limit = Map.get(params, "limit", 20)
    offset = Map.get(params, "offset", 0)

    # TODO: Implement Followed users research and model

    conn
  end

  @doc """
  Returns the article with the corresponding slug
  """
  def article_by_slug(conn, %{"slug" => slug}) do
    IO.inspect slug
    article = Repo.all(from a in Article, where: like(a.slug, ^slug))

    case article do
      [] ->
        conn
        |> put_status(404)
        |> json(%{"error" => "The given article does not exists."})
      [article | _ ] ->
        json conn, article
    end
  end

  @doc """
  Creates a new article
  Required fields: title, description, body
  Optional fields: tagList
  """
  def create_article(conn, %{"article" => params}) do
    case create_article_from_params(params) do
      {:ok, article} ->
        case insert_article_in_database(article) do
          {:ok, article} ->
            if Map.has_key?(params, "tagList") do
              case insert_article_tags(article, Map.get(params, "tagList")) do
                :ok -> json(conn, %{"success" => "Article and tags added."})
                {:error, message} ->
                  conn
                  |> put_status(500)
                  |> json(%{"error" => message})
              end
            else
              json(conn, %{"success" => "Article added."})
            end
          {:error, message} ->
            conn
            |> put_status(500)
            |> json(%{"error" => message})
        end

      {:error, message} ->
        conn
        |> put_status(400)
        |> json(%{"error" => message})
    end
  end

  def create_article(conn, _) do
    conn
    |> put_status(400)
    |> json(%{"error" => "Invalid request, no article provided."})
  end

  @doc """
  Update an article, giving its slug and changes
  """
  def update_article(conn, %{"slug" => slug, "article" => article}) do
    entity = Repo.get_by(Article, slug: slug)

    if is_nil(entity) do
      conn
      |> put_status(404)
      |> json(%{"error" => "Article not found."})
    else

      fields = [
        {"title", :title},
        {"description", :description},
        {"body", :body},
        {"author", :author},
        {"slug", :slug}
      ]

      changeset = fields
      |> Enum.reduce(Ecto.Changeset.change(entity, id: entity.id), fn {key, property}, acc ->
        if Map.has_key?(article, key) do
          Ecto.Changeset.put_change(acc, property, Map.get(article, key))
        else
          acc
        end
      end)

      case Repo.update(changeset) do
        {:ok, new_article} -> json(conn, new_article)
        {:error, changeset} ->
          IO.inspect changeset
          conn
          |> put_status(500)
          |> json(%{"error" => "An error occured."})
      end

    end
  end

  def update_article(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{"error" => "Invalid request. No slug or article changes found."})
  end

  @doc """
  Deletes the article with the given slug from the database

  TODO: FIX CONSTRAINTS
  """
  def delete_article(conn, %{"slug" => slug}) do
    article = Repo.get_by(Article, slug: slug)

    if is_nil(article) do
      conn
      |> put_status(404)
      |> json(%{"error" => "Article not found."})
    else
      case Repo.delete_all(from a in Article, where: a.id == ^article.id) do
        {:ok, article} ->
          json conn, %{"article" => article}
        {:error, changeset} ->
          IO.puts("[ERROR] Failed to delete article")
          IO.inspect changeset
          conn
          |> put_status(500)
          |> json(%{"error" => "Internal error, failed to delete article."})
      end
    end
  end

  def delete_article(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{"error" => "Invalid request, slug required."})
  end

end
