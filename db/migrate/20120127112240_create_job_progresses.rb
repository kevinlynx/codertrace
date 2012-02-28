class CreateJobProgresses < ActiveRecord::Migration
  def change
    create_table :job_progresses do |t|
      t.integer :sum, :default => 0
      t.integer :finished, :default => 0

      t.timestamps
    end
  end
end
