require('kanban/api')
require_relative('../../app/models/task_metric')

module Kanban
  class Crawler
    def snapshot_done_cards
      kanban_cards = Api.done_cards
      kanban_cards.each do |kanban_card|
        TaskMetric.from(kanban_card).save! if TaskMetric.missing?(kanban_card)
      end
    end
  end
end
