require 'kanban/api'
require 'kanban/board'
require 'kanban/card'
require 'csv_utility'

module Kanban
  class Report
    def self.card_and_lane
      CsvUtility.to_csv(Kanban::Api.all, :headers => [
        'Board',
        'FogBugz ID',
        'Lane'
        ]) {|card| [
          card.board,
          card.external_card_id,
          card.lane
          ] }
    end

    def self.cards_missing_size
      CsvUtility.to_csv(Kanban::Api.cards_missing_size, :headers => [
        'Board',
        'FogBugz ID',
        'Title',
        'Shepherd',
        'Lane',
        'Priority',
        'Type',
        'Block Reason'
        ]) {|card| [
          card.board,
          card.external_card_id,
          card.title,
          card.tags,
          card.lane,
          card.priority_text,
          card.type_name,
          card.block_reason
          ] }
    end

    def self.cards_missing_tags
      CsvUtility.to_csv(Kanban::Api.cards_missing_tags, :headers => [
        'Board',
        'FogBugz ID',
        'Title',
        'Estimate',
        'Lane',
        'Priority',
        'Type',
        'Block Reason'
        ]) {|card| [
          card.board,
          card.external_card_id,
          card.title,
          card.size,
          card.lane,
          card.priority_text,
          card.type_name,
          card.block_reason
          ] }
    end
  end
end
