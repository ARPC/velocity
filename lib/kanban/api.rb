require 'leankitkanban'
require 'kanban/card'
require 'active_support/core_ext/numeric/time'

module Kanban
  class Api
    def self.all(options = {})
      cards_by(options) {|lane, card| true }
    end

    def self.done_cards(options = {})
      cards_by(options) {|lane, card| ['Done', 'Ready to Release'].include?(lane['Title']) }
    end

    def self.cards_missing_size(options = {})
      cards_by(options) {|lane, card| [nil, 0].include?(card['Size']) }
    end

    def self.cards_missing_tags(options = {})
      cards_by(options) {|lane, card| lane != 'Saddle up' && [nil, ''].include?(card['Tags']) }
    end

    def self.cards_by(options = {})
      cards = []
      board = get_board(options)
      board['Lanes'].each do |lane|
        lane['Cards'].each do |card|
          yield_val = yield(lane, card) if block_given?
          cards << { :card => card, :lane => lane } if yield_val
        end
      end
      cards.map {|card| Card.new(card[:card].merge('Lane' => card[:lane]['Title'])) }
    end

    def self.get_board(options = {})
      opts = { :force_refresh => false }.merge(options)
      if (opts[:force_refresh] || @board_refreshed_at.nil? || !@board_refreshed_at.between?(10.minutes.ago, 0.minutes.ago))
        @board = LeanKitKanban::Board.find(46341228).first
        @board_refreshed_at = Time.now
      end

      @board
    end
  end
end
