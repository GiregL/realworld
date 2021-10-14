defmodule Realworld.Realworld.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :bio, :string
    field :email, :string
    field :image, :binary
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :username, :bio, :image])
    |> validate_required([:email, :password, :username, :bio, :image])
  end
end
