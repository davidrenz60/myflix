class ChangeCoverUrlsToCover < ActiveRecord::Migration
  def change
    add_column :videos, :large_cover, :string
    add_column :videos, :small_cover, :string
    remove_column :videos, :large_cover_url, :string
    remove_column :videos, :small_cover_url, :string
  end
end
