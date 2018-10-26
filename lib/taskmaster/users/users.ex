defmodule Taskmaster.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Taskmaster.Repo

  alias Taskmaster.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do Repo.get!(User, id) |> Repo.preload(:manager) end
  def get_user(id) do Repo.get(User, id) |> Repo.preload(:manager) end

  def get_user_by_username(username), do: Repo.get_by(User, username: username)

  # Lists the managees of a user with provided id. If the user does not exist, returns nil.
  def list_user_managees(id) do
    user = Repo.get(User, id)
    if user do
      user = Repo.preload(user, :managees)
      user.managees
    else
      nil
    end
  end

  def list_user_tasks(id) do
    user = Repo.get(User, id)
    if user do
      user = Repo.preload(user, [tasks: :time_blocks])
      user.tasks
    else
      nil
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
    Return whether the user with the given id exists.
  """
  def user_exists(id) do
    Repo.get(User, id) != nil
  end
end
