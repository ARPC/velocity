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

  def report
  end

  def download_extract
    csv = CSV.generate do |csv|
      csv << ['FogBugz ID', 'Lane']
      Kanban::Api.all.each do |card|
        csv << [card.external_card_id, card.lane]
      end
    end
    send_data csv, filename: 'extract.csv', type: 'application/csv'
  end

  def download_missing_estimates
    csv = CSV.generate do |csv|
      csv << ['FogBugz ID', 'Title', 'Shepherd', 'Lane', 'Priority', 'Type', 'Block Reason']
      Kanban::Api.all.each do |card|
        csv << [card.external_card_id, card.title, card.tags, card.lane, card.priority_text, card.type_name, card.block_reason]
      end
    end
    send_data csv, filename: 'missing_estimates.csv', type: 'application/csv'
  end

  def download_missing_shepherds
    csv = CSV.generate do |csv|
      csv << ['FogBugz ID', 'Title', 'Estimate', 'Lane', 'Priority', 'Type', 'Block Reason']
      Kanban::Api.all.each do |card|
        csv << [card.external_card_id, card.title, card.size, card.lane, card.priority_text, card.type_name, card.block_reason]
      end
    end
    send_data csv, filename: 'missing_shepherds.csv', type: 'application/csv'
  end
end
