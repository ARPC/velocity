require_relative('../../app/models/card')

module Kanban
  class Crawler
    def snapshot_done_cards
      kanban_cards = Api.done_cards
      kanban_cards.each do |kanban_card|
        Card.from(kanban_card).save! if Card.missing?(kanban_card)
      end
    end
  end
end
