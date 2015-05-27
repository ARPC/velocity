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

  def self.get_velocity_information
    all_velocities = Analytics.velocity().to_a
    all_velocities.length < 12 ? first = all_velocities.length : first = 12
    chart_data = all_velocities[-first..-2].to_h
    avg_velocity = avg(all_velocities)
    all_velocities.length < 5 ? first = all_velocities.length : first = 5
    last_4_avg_velocity = avg(all_velocities[-first..-2])
    current_velocity = 0
    unless all_velocities.nil? || all_velocities.empty?
      current_velocity = all_velocities.last[1]
    end

    { :chart_data => chart_data, :avg_velocity => avg_velocity, :last_4_avg_velocity => last_4_avg_velocity, :current_velocity => current_velocity }
  end

  def self.avg(velocities)
    if velocities.nil? || velocities.empty?
      0
    else
      avg = velocities.inject(0.0) {|result, el| result + el[1]}/velocities.size.to_f
      avg
    end
  end

end
