defmodule Realworld.Articles.GetArticles do
  @moduledoc """
  Module that contains functions to fetch articles from the database
  """

  alias Realworld.Articles.Article
  alias Realworld.Repo

  @doc """
  Get an article from the database by its slug.
  """
  @spec get_by_slug(String.t()) :: nil | Article.t()
  def get_by_slug(slug) do
    Repo.get_by(Article, [slug: slug])
  end

end
