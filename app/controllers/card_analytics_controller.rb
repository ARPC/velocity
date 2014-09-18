require 'kanban'
require 'csv'

class CardAnalyticsController < ApplicationController
  def velocity
    @velocity = TaskMetric.where(:done_at => 1.weeks.ago..0.weeks.ago).map(&:estimate).inject(0, :+)
    respond_to do |format|
      format.html
      format.json { render json: @velocity }
    end
  end

  def extract
  end

  def download_extract
    csv = CSV.generate do |csv|
      csv << ['FogBugzId', 'Lane']
      Kanban::Api.all.each do |card|
        csv << [card.external_card_id, card.lane]
      end
    end
    send_data csv, filename: 'extract.csv', type: 'application/csv'
  end
end
