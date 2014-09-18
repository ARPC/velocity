require 'leankitkanban'
require 'kanban/card'

module Kanban
  class Api
    def self.done_cards
      board = get_board
      done_lane = board['Lanes'].select {|lane| lane['Title'] == 'Done'}.first
      return [] if done_lane.nil?
      done_lane['Cards'].map {|card| Card.new(card) }
    end

    def self.cards_missing_size
      cards_missing_by('Size', [nil, 0])
    end

    def self.cards_missing_tags
      cards_missing_by('Tags', [nil, ''])
    end

    def self.get_board
      LeanKitKanban::Board.find(46341228).first
    end

    def self.cards_missing_by(field, values_considered_missing)
      cards = []
      board = get_board
      board['Lanes'].each do |lane|
        lane['Cards'].each do |card|
          cards << card if values_considered_missing.include?(card[field])
        end
      end
      cards.map {|card| Card.new(card) }
    end
  end
end
