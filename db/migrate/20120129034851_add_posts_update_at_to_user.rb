class AddPostsUpdateAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :posts_update_at, :datetime, :default => Time.utc(1986)
  end
end
