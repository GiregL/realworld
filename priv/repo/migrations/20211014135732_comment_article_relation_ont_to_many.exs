defmodule Realworld.Repo.Migrations.CommentArticleRelationOntToMany do
  use Ecto.Migration

  def change do
    # Adds the article the comment is pointing at
    alter table(:comments) do
      add :article, references(:articles)
    end
  end
end
