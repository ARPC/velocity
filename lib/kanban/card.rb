require 'kanban/board'

module Kanban
  class Card
    def initialize(json = {})
      @json = json
    end

    def method_missing(meth, *args, &block)
      key = meth.to_s
      if (is_assignment(key))
        @json[key.gsub('=', '')] = args[0]
        return args
      end

      return @json[key] if @json.has_key?(key)

      key_matching_downcase = @json.keys.select {|k| clean_key(k) == clean_key(key) }.first
      return @json[key_matching_downcase] unless key_matching_downcase.nil?

      super
    end

    def clean_key(key)
      key.to_s.downcase.gsub('_', '')
    end

    def is_assignment(key)
      key.end_with?('=')
    end

    def is_completed
      name = value_of('Lane', '')
      Board.get_lane_type(name) == 'completed'
    end

    def is_in_backlog
      name = value_of('Lane', '')
      Board.get_lane_type(name) == 'backlog'
    end

    def is_missing_size
      value_of('Size', 0) <= 0
    end

    def is_missing_tags
      value_of('Tags', '').empty?
    end

    def week_of
      text = value_of('LastMove', DateTime.now.to_s)
      date = DateTime.parse(text)
      date.beginning_of_week(:thursday)
    end

    def value_of(name, default)
      @json[name].nil? ? default : @json[name]
    end
  end
end
