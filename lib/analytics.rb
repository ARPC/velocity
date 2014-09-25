require_relative '../app/models/task_metric'

class Analytics
  def self.velocity(opts = {})
    options = {}.merge(opts)
    if (options.has_key?(:from))
      velocities = TaskMetric.where { done_at >= options[:from] }.group_by_week(:done_at, :format => '%m/%d/%Y').sum(:estimate)
    else
      velocities = TaskMetric.group_by_week(:done_at, :format => '%m/%d/%Y').sum(:estimate)
    end
    velocities
  end
end
