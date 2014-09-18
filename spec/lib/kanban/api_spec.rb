require('kanban/api')

describe Kanban::Api do
  before(:each) do
    @wip_lane = { 'Title' => 'WIP', 'Cards' => [{'Id' => 1}, {'Id' => 2}] }
    @done_lane = { 'Title' => 'Done', 'Cards' => [{'Id' => 3}, {'Id' => 4}] }
    @ready_to_release_lane = { 'Title' => 'Ready to Release', 'Cards' => [{'Id' => 5}, {'Id' => 6}] }
    @lkk_response = { 'Lanes' => [@wip_lane, @done_lane, @ready_to_release_lane] }

    expect(LeanKitKanban::Board).to receive(:find).with(46341228).and_return([@lkk_response])
  end

  context '#done_cards' do
    it 'returns Kanban::Card objects' do
      cards = Kanban::Api.done_cards
      cards.each {|card| expect(card).to be_a(Kanban::Card) }
    end

    it 'provides the cards in Done lane' do
      cards = Kanban::Api.done_cards
      expect(cards.map {|card| card.id}).to include(get_card_id(@done_lane, 0), get_card_id(@done_lane, 1))
    end

    it 'provides the cards in Ready To Release lane' do
      cards = Kanban::Api.done_cards
      expect(cards.map {|card| card.id}).to include(get_card_id(@ready_to_release_lane, 0), get_card_id(@ready_to_release_lane, 1))
    end

    it 'ignores non-done cards' do
      @lkk_response['Lanes'].delete(@done_lane)
      @lkk_response['Lanes'].delete(@ready_to_release_lane)
      expect(Kanban::Card).not_to receive(:new).with(any_args)
      expect(Kanban::Api.done_cards).to eq([])
    end
  end

  context '#cards_missing_size' do
    before(:each) do
      @wip_lane['Cards'][0].delete('Size')
      @wip_lane['Cards'][1]['Size'] = 54
      @ready_to_release_lane['Cards'][0].delete('Size')
      @ready_to_release_lane['Cards'][1]['Size'] = 99
      @done_lane['Cards'][0].delete('Size')
      @done_lane['Cards'][1]['Size'] = 12
    end

    it 'provides cards without sizes' do
      cards = Kanban::Api.cards_missing_size
      expect(cards.map {|card| card.id}).to contain_exactly(get_card_id(@wip_lane, 0), get_card_id(@ready_to_release_lane, 0), get_card_id(@done_lane, 0))
    end

    it 'treats cards with 0 size as without size' do
      @wip_lane['Cards'][0]['Size'] = 0
      @ready_to_release_lane['Cards'][0]['Size'] = 0
      @done_lane['Cards'][0]['Size'] = 0
      cards = Kanban::Api.cards_missing_size
      expect(cards.map {|card| card.id}).to contain_exactly(get_card_id(@wip_lane, 0), get_card_id(@ready_to_release_lane, 0), get_card_id(@done_lane, 0))
    end

    it 'ignores cards with sizes' do
      cards = Kanban::Api.cards_missing_size
      expect(cards.map {|card| card.id}).not_to contain_exactly(get_card_id(@wip_lane, 1), get_card_id(@ready_to_release_lane, 1), get_card_id(@done_lane, 1))
    end
  end

  context '#cards_missing_tags' do
    before(:each) do
      @wip_lane['Cards'][0].delete('Tags')
      @wip_lane['Cards'][1]['Tags'] = 'Shepherd: CJ'
      @ready_to_release_lane['Cards'][0].delete('Tags')
      @ready_to_release_lane['Cards'][1]['Tags'] = 'Shepherd: MI'
      @done_lane['Cards'][0].delete('Tags')
      @done_lane['Cards'][1]['Tags'] = 'Shepherd: BC'
    end

    it 'provides cards without tags' do
      cards = Kanban::Api.cards_missing_tags
      expect(cards.map {|card| card.id}).to contain_exactly(get_card_id(@wip_lane, 0), get_card_id(@ready_to_release_lane, 0), get_card_id(@done_lane, 0))
    end

    it 'treats cards with blank tags as without tags' do
      @wip_lane['Cards'][0]['Tags'] = ''
      @ready_to_release_lane['Cards'][0]['Tags'] = ''
      @done_lane['Cards'][0]['Tags'] = ''
      cards = Kanban::Api.cards_missing_tags
      expect(cards.map {|card| card.id}).to contain_exactly(get_card_id(@wip_lane, 0), get_card_id(@ready_to_release_lane, 0), get_card_id(@done_lane, 0))
    end

    it 'ignores cards with tags' do
      cards = Kanban::Api.cards_missing_tags
      expect(cards.map {|card| card.id}).not_to contain_exactly(get_card_id(@wip_lane, 1), get_card_id(@ready_to_release_lane, 1), get_card_id(@done_lane, 1))
    end
  end

  def get_card_id(lane, card_index)
    lane['Cards'][card_index]['Id']
  end
end
