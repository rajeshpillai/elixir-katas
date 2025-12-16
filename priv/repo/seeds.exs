# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ElixirKatas.Repo.insert!(%ElixirKatas.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ElixirKatas.Accounts

# Create demo user for Tasky
{:ok, _user} = Accounts.register_user(%{
  email: "demo1",
  password: "demo123"
})

IO.puts("Demo user created: demo1 / demo123")
