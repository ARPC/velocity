require 'active_record'
require('kanban/crawler')

describe Kanban::Crawler do
  context '#snapshot_done_cards' do
    it 'saves card metric for newly done kanban cards' do
      missing = double
      cards = [missing]
      expect(Kanban::Api).to receive(:done_cards).and_return(cards)

      new_metric = double
      expect(TaskMetric).to receive(:from).with(missing).and_return new_metric
      expect(TaskMetric).to receive(:saveable?).with(missing).and_return(true)
      expect(new_metric).to receive(:save!)
      subject.snapshot_done_cards
    end

    it 'does not enter duplicate card metrics' do
      not_missing = double
      cards = [not_missing]
      expect(Kanban::Api).to receive(:done_cards).and_return(cards)

      expect(TaskMetric).to receive(:saveable?).with(not_missing).and_return(false)
      subject.snapshot_done_cards
    end
  end
end
