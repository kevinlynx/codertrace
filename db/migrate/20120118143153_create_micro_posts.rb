class CreateMicroPosts < ActiveRecord::Migration
  def change
    create_table :micro_posts do |t|
      t.text :description
      t.string :url
      t.string :title
      t.integer :user_id
      t.datetime :pub_date
      t.integer :user_id

      t.timestamps
    end
   add_index :micro_posts, :user_id
  end
end
