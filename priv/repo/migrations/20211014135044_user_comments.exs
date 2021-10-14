defmodule Realworld.Repo.Migrations.UserComments do
  use Ecto.Migration

  def change do
    # Add the comment author relationship
    alter table(:comments) do
      add :author, references(:users)
    end
  end
end
