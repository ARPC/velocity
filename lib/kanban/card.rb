module Kanban
  class Card
    def initialize(json = {})
      @json = json
    end

    def method_missing(meth, *args, &block)
      key = meth.to_s
      return @json[key] if @json.has_key?(key)

      key_matching_downcase = @json.keys.select {|k| clean_key(k) == clean_key(key) }.first
      return @json[key_matching_downcase] unless key_matching_downcase.nil?

      super
    end

    def clean_key(key)
      key.to_s.downcase.gsub('_', '')
    end
  end
end
