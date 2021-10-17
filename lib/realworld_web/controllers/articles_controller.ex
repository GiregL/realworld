defmodule RealworldWeb.ArticlesController do
  use RealworldWeb, :controller

  @moduledoc """
  Article controller
  """

  alias Realworld.{Repo, Realworld.Article, Realworld.TagArticle, Realworld.Tag}
  import Ecto.Query

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
    tagList = Map.get(params, "tagList", [])

    #
    # If the required keys are not found
    if not Map.has_key?(params, "title")
      or not Map.has_key?(params, "description")
      or not Map.has_key?(params, "body") do

      conn
      |> put_status(400)
      |> json(%{"error" => "Required fields not found: title, description, body"})

    #
    # If the required keys are found
    else

      article = %Article{
        title: Map.get(params, "title"),
        description: Map.get(params, "description"),
        body: Map.get(params, "body"),
        author: Map.get(params, "author"),
        slug: Map.get(params, "slug")
      }

      case Repo.insert(article) do
        {:ok, inserted} ->
          article_id = inserted.id

          #
          # Adding all the tags to the new article
          taglist_insertion = tagList
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
          if taglist_insertion do
            conn
            |> put_status(201)
            |> json(%{"success" => "Article added."})
          else
            conn
            |> put_status(500)
            |> json(%{"error" => "An error occured during tag association to the new article"})
          end

        {:error, _} ->
          conn
          |> put_status(500)
          |> json(%{"error" => "Internal error, failed to insert new article."})
      end
    end
  end

  def create_article(conn, _params), do: conn |> put_status(400) |> json(%{"error" => "Invalid request, no article found."})

end
