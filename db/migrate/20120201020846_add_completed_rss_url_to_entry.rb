class AddCompletedRssUrlToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :completed, :integer
    add_column :entries, :rss_url, :string
  end
end
