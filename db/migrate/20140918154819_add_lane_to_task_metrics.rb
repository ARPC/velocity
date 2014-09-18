class AddLaneToTaskMetrics < ActiveRecord::Migration
  def change
    add_column :task_metrics, :lane, :string
  end
end
