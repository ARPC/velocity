require 'kanban'
require 'analytics'
require 'csv_utility'

class CardAnalyticsController < ApplicationController
  def velocity

    data = Analytics.get_velocity_information
    @chart_data = data[:chart_data]
    @last_week_velocity = data[:last_week_velocity]
    @avg_velocity = data[:avg_velocity]
    @velocity = data[:current_velocity]
    @last_4_avg_velocity = data[:last_4_avg_velocity]
    @cards_this_week = Analytics.cards_this_week
    @cards_last_week = Analytics.cards_last_week
    @cards_in_the_past_week = Analytics.cards_in_the_past_week
    @total_cards = Analytics.total_cards
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
