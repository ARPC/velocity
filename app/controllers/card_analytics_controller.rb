require 'kanban'

class CardAnalyticsController < ApplicationController
  def velocity
    @velocity = TaskMetric.where(:done_at => 1.weeks.ago..0.weeks.ago).map(&:estimate).inject(0, :+)
    @chart_data = TaskMetric.where { done_at >= 12.weeks.ago }.group_by_week(:done_at, :format => '%m/%d/%Y').sum(:estimate)
    respond_to do |format|
      format.html
      format.json { render json: @velocity }
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
end
