require('kanban/crawler')
require('kanban/api')
require_relative('../../../app/models/card')

describe Kanban::Crawler do
  context '#snapshot_done_cards' do
    it 'saves card metric for newly done kanban cards' do
      missing = double
      cards = [missing]

      new_card = double
      expect(Card).to receive(:from).with(missing).and_return new_card
      expect(new_card).to receive(:save!)
      expect(Card).to receive(:missing?).with(missing).and_return(true)
      subject.snapshot_done_cards
    end

    it 'does not enter duplicate card metrics' do
      not_missing = double
      cards = [not_missing]

      expect(Card).to receive(:missing?).with(not_missing).and_return(false)
      subject.snapshot_done_cards
    end
  end
end
