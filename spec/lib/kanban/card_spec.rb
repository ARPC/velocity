require 'kanban/card'
require 'rails_helper'
require 'time'
require 'analytics'

describe Kanban::Card do
  before(:each) do
    allow(Kanban::Config).to receive(:backlog_lanes).and_return(['Backlog'])
    allow(Kanban::Config).to receive(:active_lanes).and_return(['Active'])
    allow(Kanban::Config).to receive(:completed_lanes).and_return(['Completed'])
  end

  context '#method_missing' do
    let(:card) { Kanban::Card.new({ 'Id' => 11, 'Title' => 'Card Title', 'ExternalCardID' => 123, 'Size' => 13 }) }

    it 'maps fields' do
      expect(card.id).to eq(11)
      expect(card.title).to eq('Card Title')
      expect(card.external_card_id).to eq(123)
      expect(card.size).to eq(13)
    end

    context '#week_of is thursday' do
      it 'is same' do
        card.LastMove = DateTime.new(2015, 1, 29).to_s
        expect(card.week_of).to eq(DateTime.new(2015, 1, 29))
      end
      it 'was wednesday' do
        card.LastMove = DateTime.new(2015, 2, 4).to_s
        expect(card.week_of).to eq(DateTime.new(2015, 1, 29))
      end
      it 'was tuesday' do
        card.LastMove = DateTime.new(2015, 2, 3).to_s
        expect(card.week_of).to eq(DateTime.new(2015, 1, 29))
      end
      it 'was monday' do
        card.LastMove = DateTime.new(2015, 2, 2).to_s
        expect(card.week_of).to eq(DateTime.new(2015, 1, 29))
      end
      it 'was sunday' do
        card.LastMove = DateTime.new(2015, 2, 1).to_s
        expect(card.week_of).to eq(DateTime.new(2015, 1, 29))
      end
      it 'was saturday' do
        card.LastMove = DateTime.new(2015, 1, 31).to_s
        expect(card.week_of).to eq(DateTime.new(2015, 1, 29))
      end
      it 'was friday' do
        card.LastMove = DateTime.new(2015, 1, 30).to_s
        expect(card.week_of).to eq(DateTime.new(2015, 1, 29))
      end
    end

    context '#is_missing_size' do
      it 'is not when greater than zero' do
        expect(card.size).to eq(13)
        expect(card.is_missing_size).to eq(false)
      end

      it 'is when zero' do
        card.Size = 0
        expect(card.is_missing_size).to eq(true)
      end

      it 'is missing size' do
        card.Size = nil
        expect(card.is_missing_size).to eq(true)
      end
    end

    context '#is_missing_tags' do
      it 'is not when not blank' do
        card.Tags = 'present'
        expect(card.is_missing_tags).to eq(false)
      end

      it 'is when blank' do
        card.Tags = ''
        expect(card.is_missing_tags).to eq(true)
      end

      it 'is when missing' do
        card.Tags = nil
        expect(card.is_missing_tags).to eq(true)
      end
    end

    context '#is_in_backlog' do
      it 'is' do
        card.Lane = 'Backlog'
        expect(card.is_in_backlog).to eq(true)
      end

      it 'is not' do
        card.Lane = 'not backlog'
        expect(card.is_in_backlog).to eq(false)
      end
    end

    context '#is_completed' do
      it 'is' do
        card.Lane = 'Completed'
        expect(card.is_completed).to eq(true)
      end

      it 'is not' do
        card.Lane = 'not completed'
        expect(card.is_completed).to eq(false)
      end
    end

    it 'maps fields using case-insensitive keys' do
      expect(card.send(:Title)).to eq('Card Title')
    end

    it 'does not respond to keys missing in JSON' do
      expect(card).not_to respond_to(:not_a_real_key)
    end

    it 'can assign values' do
      the_time = Time.now

      card = Kanban::Card.new
      card.id = 123
      card.external_card_id = 12345
      card.title = 'my card title'
      card.size = 4
      card.last_move = the_time

      expect(card.id).to eq(123)
      expect(card.external_card_id).to eq(12345)
      expect(card.title).to eq('my card title')
      expect(card.size).to eq(4)
      expect(card.last_move).to eq(the_time)
    end
  end
end
