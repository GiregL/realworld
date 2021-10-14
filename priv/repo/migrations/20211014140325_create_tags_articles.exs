defmodule Realworld.Repo.Migrations.CreateTagsArticles do
  use Ecto.Migration

  def change do
    create table(:tags_articles) do
      add :article, references(:articles, on_delete: :nothing)
      add :tag, references(:tags, on_delete: :nothing)

      timestamps()
    end

    create index(:tags_articles, [:article])
    create index(:tags_articles, [:tag])
  end
end
