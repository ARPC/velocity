require 'leankitkanban'
require 'kanban/card'

module Kanban
  class Api
    def self.done_cards
      board = LeanKitKanban::Board.find(46341228).first
      done_lane = board['Lanes'].select {|lane| lane['Title'] == 'Done'}.first
      return [] if done_lane.nil?
      done_lane['Cards'].map {|card| Card.new(card) }
    end
  end
end
