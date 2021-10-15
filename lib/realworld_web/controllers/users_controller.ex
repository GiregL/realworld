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

  @doc """
  Updates a user and returns it
  """
  def update_user(conn, %{"user" => user}) when is_map(user) do
    case Map.get(user, "id") do
      nil ->
        conn
        |> put_status(400)
        |> json(%{"error" => "Wrong request."})

      id ->
        user_data = Repo.get_by(User, id: id)

        cond do
          user_data == nil ->
            conn
            |> put_status(404)
            |> json(%{"error" => "The given user doesn't exists."})

          true ->
            fields = [{"email", :email}, {"username", :username}, {"password", :password}, {"image", :image}, {"bio", :bio}]
            changeset = fields
            |> Enum.reduce(Ecto.Changeset.change(user_data, id: id), fn {key, property}, acc ->
              if Map.has_key?(user, key) do
                Ecto.Changeset.put_change(acc, property, Map.get(user, key))
              else
                acc
              end
            end)

            case Repo.update(changeset) do
              {:ok, new_user} -> json(conn, new_user)
              {:error, changeset} ->
                IO.inspect changeset
                conn
                |> put_status(500)
                |> json(%{"error" => "An error occured."})
            end
        end
    end
  end
end
