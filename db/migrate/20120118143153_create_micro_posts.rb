class CreateMicroPosts < ActiveRecord::Migration
  def change
    create_table :micro_posts do |t|
      t.text :description
      t.string :url
      t.string :title
      t.integer :user_id
      t.datetime :pub_date

      t.timestamps
    end
  end
end
