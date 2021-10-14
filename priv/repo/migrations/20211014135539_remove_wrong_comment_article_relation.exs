defmodule Realworld.Repo.Migrations.RemoveWrongCommentArticleRelation do
  use Ecto.Migration

  def change do
    drop_if_exists table(:article_comments)
  end
end
