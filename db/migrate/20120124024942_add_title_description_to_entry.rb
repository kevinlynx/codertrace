class AddTitleDescriptionToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :title, :string, :default => "no title"
    add_column :entries, :description, :string, :default => "no description"
  end
end
