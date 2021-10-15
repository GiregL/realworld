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

end
