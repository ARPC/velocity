require 'kanban'
require 'analytics'
require 'csv_utility'

class CardAnalyticsController < ApplicationController
  def velocity
    @all_velocities = Analytics.velocity.to_a
    @chart_data = @all_velocities[-12..-1].to_h
    @avg_velocity = avg(@all_velocities)
    @last_4_avg_velocity = avg(@all_velocities[-5..-2])
    if @chart_data.nil? || @chart_data.empty?
      @velocity = 0
    else
      @velocity = @chart_data.to_a.last[1]
    end
    respond_to do |format|
      format.html
      format.json { render json: @chart_data }
    end
  end

  def avg(velocities)
    if velocities.nil? || velocities.empty?
      0
    else
      velocities.inject(0.0) {|result, el| result + el[1]}/velocities.size.to_f
    end
  end

  def report
  end

  def download_extract
    csv = Kanban::Report.card_and_lane
    send_data csv, filename: 'extract.csv', type: 'application/csv'
  end

  def download_missing_estimates
    csv = Kanban::Report.cards_missing_size
    send_data csv, filename: 'missing_estimates.csv', type: 'application/csv'
  end

  def download_missing_shepherds
    csv = Kanban::Report.cards_missing_tags
    send_data csv, filename: 'missing_shepherds.csv', type: 'application/csv'
  end

  def download_velocity_extract
    analytics = Analytics.velocity
    csv = CsvUtility.to_csv(analytics, :headers => ['Week Of', 'Velocity']) {|analytic| [analytic[0], analytic[1]] }
    send_data csv, filename: 'velocity_extract.csv', type: 'application/csv'
  end
end
