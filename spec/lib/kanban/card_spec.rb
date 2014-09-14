require 'kanban/card'

describe Kanban::Card do
  context '#method_missing' do
    let(:card) { Kanban::Card.new({ 'Title' => 'Card Title', 'ExternalCardID' => 123, 'Size' => 13 }) }

    it 'maps fields' do
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
  end
end
