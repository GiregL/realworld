defmodule Realworld.Realworld.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :author, :id
    field :article, :id
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :author, :article])
    |> validate_required([:body, :author, :article])
  end
end
