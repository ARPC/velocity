class TaskMetric < ActiveRecord::Base
  def self.from(card)
    metric = TaskMetric.new
    metric.leankit_id = card.id
    metric.fog_bugz_id = card.external_card_id
    metric.title = card.title
    metric.estimate = card.size
    metric.done_at = card.last_move
    metric
  end

  def self.missing?(card)
    find_by_id(card.id).nil?
  end
end
