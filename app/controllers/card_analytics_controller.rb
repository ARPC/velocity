require 'kanban'
require 'analytics'
require 'csv_utility'

class CardAnalyticsController < ApplicationController
  def velocity
    @chart_data = Analytics.velocity(:from => 12.weeks.ago)
    @velocity = @chart_data.to_a.last[1]
    respond_to do |format|
      format.html
      format.json { render json: @chart_data }
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
