class TaskMetric < ActiveRecord::Base
  def self.from(card)
    puts "card id: #{card.id}, LastMove: #{card.last_move}"
    TaskMetric.new({
      :leankit_id => card.id,
      :fog_bugz_id => card.external_card_id,
      :title => card.title,
      :estimate => card.size,
      :done_at => card.last_move
    })
  end

  def self.missing?(card)
    find_by_leankit_id(card.id).nil?
  end
end
