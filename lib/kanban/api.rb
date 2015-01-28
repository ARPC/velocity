require 'leankitkanban'
require 'kanban/card'
require 'kanban/config'
require 'kanban/board'
require 'active_support/core_ext/numeric/time'

module Kanban
  class Api
    @@cache_refreshed_at = DateTime.new(1970, 1, 1)
    @@cache = []

    def self.done_cards(options = {})
      self.all_cards(options).find_all {|card| card.is_completed }
    end

    def self.cards_missing_size(options = {})
      self.all_cards(options).find_all {|card| card.is_missing_size }
    end

    def self.cards_missing_tags(options = {})
      self.all_cards(options).find_all {|card| card.is_missing_tags && !card.is_in_backlog }
    end

    def self.all_cards(options = {})
      all_cards = []
      boards = get_boards(options)
      boards.each do |board|
        all_cards += board.get_cards(options)
      end
      all_cards
    end

    def self.clear_cache
      @@cache_refreshed_at = DateTime.new(1970, 1, 1)
      @@cache = []
    end

    def self.ignore_cache(options)
      opts = { :force_refresh => false }.merge(options)

      if opts[:force_refresh]
        return true
      end

      !@@cache_refreshed_at.between?(10.minutes.ago, 0.minutes.ago)
    end

    def self.get_boards(options = {})
      if self.ignore_cache options
        @@cache = LeanKitKanban::Board.all
        @@cache_refreshed_at = Time.now
      end

      valid_boards = Kanban::Config.board_ids

      all_boards = []
      @@cache.each do |boards|
        boards.each do |board|
          id = board['Id']
          if valid_boards.include? id
            all_boards << Kanban::Board.new(id: id, title: board['Title'])
          end
        end
      end
      all_boards.flatten
    end

    def self.get_board(board_id)
      LeanKitKanban::Board.find(board_id).first
    end

  end
end
