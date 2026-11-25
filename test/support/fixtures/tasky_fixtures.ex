defmodule ElixirKatas.TaskyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirKatas.Tasky` context.
  """

  import ElixirKatas.AccountsFixtures

  @doc """
  Generate a todo. Creates a new user unless `user` is given.
  """
  def todo_fixture(user \\ nil, attrs \\ %{}) do
    user = user || user_fixture()

    attrs =
      Enum.into(attrs, %{
        is_complete: true,
        title: "some title"
      })

    {:ok, todo} = ElixirKatas.Tasky.create_todo(user.id, attrs)

    todo
  end
end
