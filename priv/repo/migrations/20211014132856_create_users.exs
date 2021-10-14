defmodule Realworld.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :username, :string
      add :bio, :string
      add :image, :binary

      timestamps()
    end
  end
end
