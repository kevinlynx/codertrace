class AddTagToMicroPost < ActiveRecord::Migration
  def change
    add_column :micro_posts, :tag, :string
  end
end
