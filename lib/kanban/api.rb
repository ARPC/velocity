require 'leankitkanban'
require 'kanban/card'
require 'active_support/core_ext/numeric/time'

module Kanban
  class Api
    def self.all
      cards = []
      board = get_board
      board['Lanes'].each do |lane|
        lane['Cards'].each do |card|
          cards << { :card => card, :lane => lane }
        end
      end
      cards.map {|card| Card.new(card[:card].merge('Lane' => card[:lane]['Title'])) }
    end

    def self.done_cards
      cards = []
      board = get_board
      done_lanes = board['Lanes'].select {|lane| ['Done', 'Ready to Release'].include?(lane['Title'])}
      done_lanes.each do |lane|
        lane['Cards'].each do |card|
          cards << { :card => card, :lane => lane }
        end
      end
      cards.map {|card| Card.new(card[:card].merge('Lane' => card[:lane]['Title'])) }
    end

    def self.cards_missing_size
      cards_missing_by('Size', [nil, 0])
    end

    def self.cards_missing_tags
      cards_missing_by('Tags', [nil, ''])
    end

    def self.get_board
      if (@board_refreshed_at.nil? || !@board_refreshed_at.between?(10.minutes.ago, 0.minutes.ago))
        puts "refreshing board!"
        @board = LeanKitKanban::Board.find(46341228).first
        @board_refreshed_at = Time.now
      end

      @board
    end

    def self.cards_missing_by(field, values_considered_missing)
      cards = []
      board = get_board
      board['Lanes'].each do |lane|
        lane['Cards'].each do |card|
          cards << { :card => card, :lane => lane } if values_considered_missing.include?(card[field])
        end
      end
      cards.map {|card| Card.new(card[:card].merge('Lane' => card[:lane]['Title'])) }
    end
  end
end
