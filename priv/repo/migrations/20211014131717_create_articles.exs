defmodule Realworld.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :description, :string
      add :body, :string
      add :article_id, :integer

      timestamps()
    end
  end
end
