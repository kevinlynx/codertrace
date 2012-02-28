class AddDescriptionToMicroPost < ActiveRecord::Migration
  def change
    change_column :micro_posts, :description, :text, :limit => 4294967295
  end
end
