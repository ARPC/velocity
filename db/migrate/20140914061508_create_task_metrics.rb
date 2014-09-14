class CreateTaskMetrics < ActiveRecord::Migration
  def change
    create_table :task_metrics do |t|
      t.integer :leankit_id
      t.integer :fog_bugz_id
      t.string :title
      t.integer :estimate

      t.timestamps
    end
  end
end
