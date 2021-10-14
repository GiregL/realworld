defmodule Realworld.Repo.Migrations.CreateArticleComments do
  use Ecto.Migration

  def change do
    create table(:article_comments) do
      add :article_id, references(:articles)
      add :comment_id, references(:comments)

      timestamps()
    end
  end
end
