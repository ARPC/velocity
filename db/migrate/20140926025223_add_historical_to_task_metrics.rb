class AddHistoricalToTaskMetrics < ActiveRecord::Migration
  def change
    add_column :task_metrics, :historical, :boolean
  end
end
