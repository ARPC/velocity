class TaskMetric < ActiveRecord::Base
  def self.from(card)
    TaskMetric.new({
      :leankit_id => card.id,
      :fog_bugz_id => card.external_card_id,
      :title => card.title,
      :estimate => card.size,
      :done_at => card.last_move,
      :lane => card.lane
    })
  end

  def self.saveable?(card)
    !([nil, 0].include?(card.size)) && find_by_leankit_id(card.id).nil?
  end
end
