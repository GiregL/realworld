defmodule Realworld.Realworld.TagArticle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags_articles" do
    field :article, :id
    field :tag, :id

    timestamps()
  end

  @doc false
  def changeset(tag_article, attrs) do
    tag_article
    |> cast(attrs, [])
    |> validate_required([])
  end
end
