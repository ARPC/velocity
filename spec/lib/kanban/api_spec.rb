require('kanban/api')

describe Kanban::Api do
  context '#done_cards' do
    before(:each) do
      @wip_cards = { 'Title' => 'WIP', 'Cards' => [{}, {}] }
      @done_cards = { 'Title' => 'Done', 'Cards' => [{}, {}] }
      @lkk_response = { 'Lanes' => [@wip_cards, @done_cards] }
    end


    it 'returns the cards' do
      expect(LeanKitKanban::Board).to receive(:find).with(46341228).and_return(@lkk_response)
      @done_cards['Cards'].each {|card| expect(Kanban::Card).to receive(:new).with(card) }
      Kanban::Api.done_cards
    end

    it 'only returns the done cards' do
      @lkk_response['Lanes'].delete(@done_cards)
      expect(LeanKitKanban::Board).to receive(:find).with(46341228).and_return(@lkk_response)
      expect(Kanban::Card).not_to receive(:new).with(any_args)
      expect(Kanban::Api.done_cards).to eq([])
    end
  end
end
