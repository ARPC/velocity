require('kanban/api')
require('kanban/config')
require('kanban/card')
require('kanban/board')

describe Kanban::Api do
  before(:each) do
    Kanban::Api.clear_cache

    allow(Kanban::Config).to receive(:board_ids).and_return([1])
    allow(Kanban::Config).to receive(:backlog_lanes).and_return(['Backlog 1', 'Backlog 2'])
    allow(Kanban::Config).to receive(:active_lanes).and_return(['Active 1', 'Active 2'])
    allow(Kanban::Config).to receive(:completed_lanes).and_return(['Completed 1', 'Completed 2'])
    allow(LeanKitKanban::Board).to receive(:all).and_return(
      [
        [{'Id'=>1, 'Title'=>'One'}]
      ])
  end

  context '#get_boards' do
    it 'filters boards' do
      expect(LeanKitKanban::Board).to receive(:all).and_return(
        [
          [{'Id'=>1, 'Title'=>'One'}],
          [{'Id'=>2, 'Title'=>'Two'}]
        ])

      boards = Kanban::Api.get_boards({force_refresh: true})
      expect(boards.map {|board| "#{board.id}:#{board.title}"}).to eq([
        '1:One'
        ])

    end
    it 'returns Kanban::Board objects' do
      expect(LeanKitKanban::Board).to receive(:all).and_return(
        [
          [{'Id'=>1, 'Title'=>'One'}],
          [{'Id'=>2, 'Title'=>'Two'}]
        ])
      boards = Kanban::Api.get_boards
      boards.each {|board| expect(board).to be_a(Kanban::Board) }
    end

    it 'is cached' do
      expect(Kanban::Config).to receive(:board_ids).and_return([1]).twice
      expect(LeanKitKanban::Board).to receive(:all).and_return(
        [
          [{'Id'=>1, 'Title'=>'One'}]
        ]).once

      boards = Kanban::Api.get_boards()
      boards = Kanban::Api.get_boards()

      expect(boards.map {|board| "#{board.id}:#{board.title}"}).to eq(['1:One'])

    end

    it 'can ignore cache' do
      expect(Kanban::Config).to receive(:board_ids).and_return([1]).twice
      expect(LeanKitKanban::Board).to receive(:all).and_return(
        [
          [{'Id'=>1, 'Title'=>'One'}]
        ]).twice

      boards = Kanban::Api.get_boards({force_refresh: true})
      boards = Kanban::Api.get_boards({force_refresh: true})

      expect(boards.map {|board| "#{board.id}:#{board.title}"}).to eq(['1:One'])

    end
  end
  context '#get_cards' do
    it 'filters lanes' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 1}, {'Id' => 2}]},
            {'Title' => 'Backlog 2',   'Cards' => [{'Id' => 3}, {'Id' => 4}]},
            {'Title' => 'Active 1',    'Cards' => [{'Id' => 5}, {'Id' => 6}]},
            {'Title' => 'Active 2',    'Cards' => [{'Id' => 7}, {'Id' => 8}]},
            {'Title' => 'Completed 1', 'Cards' => [{'Id' => 9}, {'Id' => 10}]},
            {'Title' => 'Completed 2', 'Cards' => [{'Id' => 11}, {'Id' => 12}]},
            {'Title' => 'Unknown 1',   'Cards' => [{'Id' => 9999}]}
          ]}
        ])
      cards = Kanban::Api.all_cards
      expect(cards.map {|card| card.id}).to eq ([1,2,3,4,5,6,7,8,9,10,11,12])
    end
    it 'returns Kanban::Card objects' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 1}]},
          ]}
        ])
      cards = Kanban::Api.all_cards
      cards.each {|card| expect(card).to be_a(Kanban::Card) }
    end
  end
  context '#done_cards' do
    it 'returns completed cards' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 1}, {'Id' => 2}]},
            {'Title' => 'Backlog 2',   'Cards' => [{'Id' => 3}, {'Id' => 4}]},
            {'Title' => 'Active 1',    'Cards' => [{'Id' => 5}, {'Id' => 6}]},
            {'Title' => 'Active 2',    'Cards' => [{'Id' => 7}, {'Id' => 8}]},
            {'Title' => 'Completed 1', 'Cards' => [{'Id' => 9}, {'Id' => 10}]},
            {'Title' => 'Completed 2', 'Cards' => [{'Id' => 11}, {'Id' => 12}]},
            {'Title' => 'Unknown 1',   'Cards' => [{'Id' => 9999}]}
          ]}
        ])
      cards = Kanban::Api.done_cards
      expect(cards.map {|card| card.id}).to eq ([9,10,11,12])
    end
  end
  context '#cards_missing_size' do

    it 'returns card with no size' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 1}]}
          ]}
        ])
      cards = Kanban::Api.cards_missing_size
      expect(cards.map {|card| card.id}).to eq ([1])
    end

    it 'returns card with size of zero' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 1, 'Size' => 0}]}
          ]}
        ])
      cards = Kanban::Api.cards_missing_size
      expect(cards.map {|card| card.id}).to eq ([1])
    end

    it 'does not return card with size' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 1, 'Size' => 1}]}
          ]}
        ])
      cards = Kanban::Api.cards_missing_size
      expect(cards.map {|card| card.id}).to eq ([])
    end

    it 'returns cards in all lanes' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 1}]},
            {'Title' => 'Active 1',    'Cards' => [{'Id' => 2}]},
            {'Title' => 'Completed 1', 'Cards' => [{'Id' => 3}]},
          ]}
        ])
      cards = Kanban::Api.cards_missing_size
      expect(cards.map {|card| card.id}).to eq ([1,2,3])
    end
  end
  context '#cards_missing_tags' do
    it 'returns cards without tags' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Active 1',    'Cards' => [
              {'Id' => 1},
              {'Id' => 2, 'Tags' => ''},
              {'Id' => 3, 'Tags' => 'a'}]},
          ]}
        ])
      cards = Kanban::Api.cards_missing_tags
      expect(cards.map {|card| card.id}).to eq ([1,2])
    end
    it 'ignores cards in backlog' do
      expect(LeanKitKanban::Board).to receive(:find).with(1).and_return(
        [
          {'Lanes' => [
            {'Title' => 'Backlog 1',   'Cards' => [{'Id' => 99}]},
            {'Title' => 'Active 1',    'Cards' => [{'Id' => 2}]},
            {'Title' => 'Completed 1', 'Cards' => [{'Id' => 3}]},
          ]}
        ])
      cards = Kanban::Api.cards_missing_tags
      expect(cards.map {|card| card.id}).to eq ([2,3])
    end
  end
end
