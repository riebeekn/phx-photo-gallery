defmodule PhotoGallery.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :photo, :string
      add :uuid, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:photos, [:user_id])
  end
end
