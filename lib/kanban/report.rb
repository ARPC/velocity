require 'kanban/api'
require 'csv'

module Kanban
  class Report
    def self.card_and_lane
      csv = CSV.generate do |csv|
        csv << ['FogBugz ID', 'Lane']
        Kanban::Api.all.each do |card|
          csv << [card.external_card_id, card.lane]
        end
      end
      csv
    end

    def self.cards_missing_size
      csv = CSV.generate do |csv|
        csv << ['FogBugz ID', 'Title', 'Shepherd', 'Lane', 'Priority', 'Type', 'Block Reason']
        Kanban::Api.cards_missing_size.each do |card|
          csv << [card.external_card_id, card.title, card.tags, card.lane, card.priority_text, card.type_name, card.block_reason]
        end
      end
      csv
    end

    def self.cards_missing_tags
      csv = CSV.generate do |csv|
        csv << ['FogBugz ID', 'Title', 'Estimate', 'Lane', 'Priority', 'Type', 'Block Reason']
        Kanban::Api.cards_missing_tags.each do |card|
          csv << [card.external_card_id, card.title, card.size, card.lane, card.priority_text, card.type_name, card.block_reason]
        end
      end
      csv
    end
  end
end
