class AddContentToFeed < ActiveRecord::Migration
  def change
    change_column :feeds, :content, :text, :limit => 4294967295
  end
end
