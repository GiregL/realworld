defmodule RealworldWeb.UsersControllerTest do
  use RealworldWeb.ConnCase

  test "GET /api/users/", %{conn: conn} do
    conn = get(conn, "/api/users")
    assert json_response(conn, 200)
    assert is_list(json_response(conn, 200))
  end
end
