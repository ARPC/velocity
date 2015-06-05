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

    chart_data_max = 6
    all_velocities.length < chart_data_max ? first = all_velocities.length : first = chart_data_max
    chart_data = all_velocities[-first..-2]

    avg_velocity = avg(all_velocities[-all_velocities.length..-2])

    all_velocities.length < 5 ? first = all_velocities.length : first = 5
    last_4_avg_velocity = avg(all_velocities[-first..-2])

    current_velocity = all_velocities[-1][1]

    last_week_velocity = all_velocities[-2][1]

    unless all_velocities.nil? || all_velocities.empty?
      current_velocity = all_velocities.last[1]
    end

    { :chart_data => chart_data, :avg_velocity => avg_velocity, :last_4_avg_velocity => last_4_avg_velocity,
      :current_velocity => current_velocity, :last_week_velocity => last_week_velocity }
  end

  def new_beginning_of_week(time)
    if [:thursday?].any? { |day| Date.today.send(day) } && Time.now.hour<13
      return time.beginning_of_week - 7*24*60*60 + 13*60*60
    else
      return time.beginning_of_week + 13*60*60 #Thursday at 1:00PM
    end
  end

  def self.number_of_cards
    Kanban::Api.all_cards.where(:created_at>new_beginning_of_week(Time.now)).count
  end

  def self.current_velocity
    self.get_velocity_information[:current_velocity]
  end

  def self.chart_data
    self.get_velocity_information[:chart_data]
  end

  def self.avg_velocity
    self.get_velocity_information[:avg_velocity]
  end

  def self.last_4_avg_velocity
    self.get_velocity_information[:last_4_avg_velocity]
  end

  def self.last_week_velocity
    self.get_velocity_information[:last_week_velocity]
  end

  def self.avg(velocities)
    if velocities.nil? || velocities.empty?
      0
    else
      velocities.inject(0.0) {|result, el| result + el[1]}/velocities.size.to_f
    end
  end
end
