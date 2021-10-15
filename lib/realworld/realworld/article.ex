defmodule Realworld.Realworld.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :body, :description, :title, :author]}
  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :author, :id

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body, :author])
    |> validate_required([:title, :description, :body, :author])
  end
end
