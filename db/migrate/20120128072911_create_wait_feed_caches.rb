class CreateWaitFeedCaches < ActiveRecord::Migration
  def change
    create_table :wait_feed_caches do |t|
      t.string :url
      t.integer :job_id

      t.timestamps
    end
  end
end
