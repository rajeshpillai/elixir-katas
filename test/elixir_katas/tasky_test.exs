defmodule ElixirKatas.TaskyTest do
  use ElixirKatas.DataCase

  alias ElixirKatas.Tasky

  describe "todos" do
    alias ElixirKatas.Tasky.Todo

    import ElixirKatas.AccountsFixtures
    import ElixirKatas.TaskyFixtures

    @invalid_attrs %{title: nil, is_complete: nil}

    setup do
      %{user: user_fixture()}
    end

    test "list_todos/2 returns only the user's todos", %{user: user} do
      todo = todo_fixture(user)
      _other = todo_fixture()

      assert %{entries: [listed], total_entries: 1} = Tasky.list_todos(user.id)
      assert listed.id == todo.id
    end

    test "list_todos/2 searches titles case-insensitively", %{user: user} do
      todo = todo_fixture(user, %{title: "Buy Milk"})
      _no_match = todo_fixture(user, %{title: "Walk dog"})

      assert %{entries: [listed]} = Tasky.list_todos(user.id, search: "milk")
      assert listed.id == todo.id
      assert Tasky.count_todos(user.id, "milk") == 1
    end

    test "get_todo!/2 returns the todo with given id", %{user: user} do
      todo = todo_fixture(user)
      assert Tasky.get_todo!(user.id, todo.id).id == todo.id
    end

    test "get_todo!/2 raises for another user's todo", %{user: user} do
      other_todo = todo_fixture()
      assert_raise Ecto.NoResultsError, fn -> Tasky.get_todo!(user.id, other_todo.id) end
    end

    test "create_todo/2 with valid data creates a todo", %{user: user} do
      valid_attrs = %{title: "some title", is_complete: true}

      assert {:ok, %Todo{} = todo} = Tasky.create_todo(user.id, valid_attrs)
      assert todo.title == "some title"
      assert todo.is_complete == true
      assert todo.user_id == user.id
    end

    test "create_todo/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Tasky.create_todo(user.id, @invalid_attrs)
    end

    test "create_todo/2 broadcasts only to the owner's topic", %{user: user} do
      other = user_fixture()
      Tasky.subscribe(other.id)

      {:ok, _todo} = Tasky.create_todo(user.id, %{title: "private"})
      refute_receive {:todo_created, _}

      Tasky.subscribe(user.id)
      {:ok, todo} = Tasky.create_todo(user.id, %{title: "mine"})
      assert_receive {:todo_created, ^todo}
    end

    test "update_todo/2 with valid data updates the todo", %{user: user} do
      todo = todo_fixture(user)
      update_attrs = %{title: "some updated title", is_complete: false}

      assert {:ok, %Todo{} = todo} = Tasky.update_todo(todo, update_attrs)
      assert todo.title == "some updated title"
      assert todo.is_complete == false
    end

    test "update_todo/2 with invalid data returns error changeset", %{user: user} do
      todo = todo_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Tasky.update_todo(todo, @invalid_attrs)
      assert Tasky.get_todo!(user.id, todo.id).title == todo.title
    end

    test "delete_todo/1 deletes the todo", %{user: user} do
      todo = todo_fixture(user)
      assert {:ok, %Todo{}} = Tasky.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Tasky.get_todo!(user.id, todo.id) end
    end

    test "change_todo/1 returns a todo changeset", %{user: user} do
      todo = todo_fixture(user)
      assert %Ecto.Changeset{} = Tasky.change_todo(todo)
    end

    test "get_subtask!/2 only returns subtasks of the given todo", %{user: user} do
      todo = todo_fixture(user)
      other_todo = todo_fixture()
      {:ok, subtask} = Tasky.create_subtask(%{title: "step", todo_id: other_todo.id})

      assert_raise Ecto.NoResultsError, fn -> Tasky.get_subtask!(todo, subtask.id) end
      assert Tasky.get_subtask!(other_todo, subtask.id).id == subtask.id
    end
  end
end
