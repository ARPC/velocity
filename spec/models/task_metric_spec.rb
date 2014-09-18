require 'kanban/card'
require 'rails_helper'

RSpec.describe TaskMetric, :type => :model do
  context '#from' do
    let(:card) do
      card = Kanban::Card.new
      card.id = 123
      card.external_card_id = 12345
      card.title = 'my card title'
      card.size = 4
      card.last_move = Time.now
      card.lane = 'The Lane'
      card
    end

    it 'loads fields from our Kanban Card wrapper' do
      metric = TaskMetric.from(card)
      expect(metric.leankit_id).to eq(card.id)
      expect(metric.fog_bugz_id).to eq(card.external_card_id)
      expect(metric.title).to eq(card.title)
      expect(metric.estimate).to eq(card.size)
      expect(metric.done_at).to eq(card.last_move)
      expect(metric.lane).to eq(card.lane)
    end
  end

  context '#saveable?' do
    let(:card) { Kanban::Card.new(:id => 123, :size => 2) }

    it 'saveable if card is new' do
      TaskMetric.delete_all(:leankit_id => 123)
      expect(TaskMetric.saveable?(card)).to eq(true)
    end

    it 'not saveable if card already persisted' do
      TaskMetric.create!(:leankit_id => 123)
      expect(TaskMetric.saveable?(card)).to eq(false)
    end

    it 'saveable if estimate is provided' do
      expect(TaskMetric.saveable?(card)).to eq(true)
    end

    it 'not saveable if size is missing' do
      card.size = 0
      expect(TaskMetric.saveable?(card)).to eq(false)
    end
  end
end
