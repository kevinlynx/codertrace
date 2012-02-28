class AddDownloadAtToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :download_at, :datetime
  end
end
