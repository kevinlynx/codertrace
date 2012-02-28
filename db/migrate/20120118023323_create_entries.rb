class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :url
      t.string :tag
      t.integer :user_id

      t.timestamps
    end
  end
end
