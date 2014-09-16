class AddDoneAtToTaskMetrics < ActiveRecord::Migration
  def change
    add_column :task_metrics, :done_at, :timestamp
  end
end
