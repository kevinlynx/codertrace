class CreateProcessJobs < ActiveRecord::Migration
  def change
    create_table :process_jobs do |t|
      t.string :url

      t.timestamps
    end
  end
end
