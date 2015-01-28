require 'kanban/card'
require 'kanban/api'

module Kanban
  class Board
    attr_accessor :id, :title

    def initialize(h)
      h.each {|k,v| send("#{k}=", v)}
      @cached_at = 11.minutes.ago
      @cache = []
    end

    def ignore_cache(options)
      opts = { :force_refresh => false }.merge(options)

      if opts[:force_refresh]
        return true
      end

      !@cached_at.between?(10.minutes.ago, 0.minutes.ago)
    end

    def self.get_lane_type(title)
      if Kanban::Config.backlog_lanes.include? title
        return 'backlog'
      end

      if Kanban::Config.active_lanes.include? title
        return 'active'
      end

      if Kanban::Config.completed_lanes.include? title
        return 'completed'
      end

      return ''
    end

    def get_cards(options = {})
      if ignore_cache options
        @cache = Api.get_board(@id)
        @cashed_at = Time.now
      end

      all_cards = []
      @cache['Lanes'].each do |lane|
        lane_title = lane['Title']
        lane_type = self.class.get_lane_type lane_title
        if ! lane_type.blank?
          cards = []
          lane['Cards'].each do |card|
            yield_val = yield(lane, card) if block_given?
            card['Board'] = @title
            card['Lane'] = lane_title
            cards << { :card => card, :lane => lane } #if yield_val
          end
          all_cards += cards.map {|card| Card.new(card[:card])}
        end
      end
      all_cards.flatten
    end
  end
end
