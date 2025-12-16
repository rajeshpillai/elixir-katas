defmodule ElixirKatas.Tasky do
  @moduledoc """
  The Tasky context.
  """

  import Ecto.Query, warn: false
  alias ElixirKatas.Repo

  alias ElixirKatas.Tasky.Todo
  @topic "tasky"

  def subscribe do
    Phoenix.PubSub.subscribe(ElixirKatas.PubSub, @topic)
  end

  defp broadcast({:ok, todo}, event) do
    Phoenix.PubSub.broadcast(ElixirKatas.PubSub, @topic, {event, todo})
    {:ok, todo}
  end
  defp broadcast({:error, _} = error, _event), do: error

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  @doc """
  Returns the list of todos.
  
  Supports pagination options: `page` (default 1) and `per_page` (default 5).
  """
  def list_todos(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 5)
    offset = (page - 1) * per_page

    search = Keyword.get(opts, :search)
    
    base_query = Todo
    
    query = if search && search != "" do
      search_term = "%#{search}%"
      from t in base_query, where: ilike(t.title, ^search_term)
    else
      base_query
    end

    query = from t in query,
      limit: ^per_page,
      offset: ^offset,
      order_by: [desc: t.inserted_at]
    
    # We need to filter the aggregate count too
    count_query = if search && search != "" do
        search_term = "%#{search}%"
        from t in Todo, where: ilike(t.title, ^search_term)
    else
        Todo
    end

    total_count = Repo.aggregate(count_query, :count, :id)
    entries = Repo.all(query)
    total_pages = ceil(total_count / per_page)
    
    %{
      entries: entries,
      page_number: page,
      page_size: per_page,
      total_pages: total_pages,
      total_entries: total_count
    }
  end

  @doc """
  Returns the total count of todos, optionally filtered by search.
  """
  def count_todos(search \\ nil) do
    query = if search && search != "" do
        search_term = "%#{search}%"
        from t in Todo, where: ilike(t.title, ^search_term)
    else
        Todo
    end
    Repo.aggregate(query, :count, :id)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:todo_created)
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
    |> broadcast(:todo_updated)
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
    |> broadcast(:todo_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
