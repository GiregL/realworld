defmodule RealworldWeb.UsersController do
  use RealworldWeb, :controller

  @moduledoc """
  Users controller

  It is used to manage users and expose those endpoints:

  GET /api/users/                       Get all users
  GET /api/users/:userId                Get a user by its id
  """

  alias Realworld.{Repo, Realworld.User}

  @doc """
  Returns a list of all the users from the database
  """
  def user_list(conn, _params) do
    json conn, Repo.all(User)
  end

  @doc """
  Returns the user with the given id
  """
  def user_by_id(conn, %{"userId" => id}) do
    json conn, Repo.get_by(User, id: id)
  end
end
