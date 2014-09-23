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

  context 'groupdate extensions' do
    it 'groups by week' do
      TaskMetric.create!(:leankit_id => 1, :estimate => 2, :done_at => 1.weeks.ago)
      TaskMetric.create!(:leankit_id => 2, :estimate => 3, :done_at => 1.weeks.ago)

      TaskMetric.create!(:leankit_id => 3, :estimate => 52, :done_at => 2.weeks.ago)
      TaskMetric.create!(:leankit_id => 4, :estimate => 22, :done_at => 2.weeks.ago)

      TaskMetric.create!(:leankit_id => 5, :estimate => 67, :done_at => 3.weeks.ago)
      TaskMetric.create!(:leankit_id => 6, :estimate => 26, :done_at => 3.weeks.ago)

      group = TaskMetric.group_by_week(:done_at).sum(:estimate)
      expect(group[1.weeks.ago.beginning_of_week]).to eq(5)
      expect(group[2.weeks.ago.beginning_of_week]).to eq(74)
      expect(group[3.weeks.ago.beginning_of_week]).to eq(93)
    end
  end
end
