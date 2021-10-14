defmodule Realworld.Repo.Migrations.UserArticles do
  use Ecto.Migration

  def change do
    # Add author user to the article
    alter table(:articles) do
      add :author, references(:users)
    end
  end
end
