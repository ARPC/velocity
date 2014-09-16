require 'kanban/card'

describe Kanban::Card do
  context '#method_missing' do
    let(:card) { Kanban::Card.new({ 'Id' => 11, 'Title' => 'Card Title', 'ExternalCardID' => 123, 'Size' => 13 }) }

    it 'maps fields' do
      expect(card.id).to eq(11)
      expect(card.title).to eq('Card Title')
      expect(card.external_card_id).to eq(123)
      expect(card.size).to eq(13)
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
