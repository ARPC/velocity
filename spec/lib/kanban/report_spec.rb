require 'kanban/report'

RSpec.describe Kanban::Report do
  let (:card1) { Kanban::Card.new(:external_card_id => 1, :lane => 'Doing', :title => 'Title 1', :tags => 'CJ', :size => 3, :priority_text => 'Normal', :type_name => 'Unassigned', :block_reason => '') }
  let (:card2) { Kanban::Card.new(:external_card_id => 2, :lane => 'Code Review', :title => 'Title 2', :tags => 'CJ', :size => 4, :priority_text => 'Normal', :type_name => 'Unassigned', :block_reason => 'bad card') }

  it 'creates card and lane extract' do
    expect(Kanban::Api).to receive(:all).and_return([card1, card2])
    csv = Kanban::Report.card_and_lane.split("\n")
    expect(csv[0]).to eq('FogBugz ID,Lane')
    expect(csv[1]).to eq('1,Doing')
    expect(csv[2]).to eq('2,Code Review')
  end

  it 'creates missing estimates report' do
    expect(Kanban::Api).to receive(:cards_missing_size).and_return([card1, card2])
    csv = Kanban::Report.cards_missing_size.split("\n")
    expect(csv[0]).to eq('FogBugz ID,Title,Shepherd,Lane,Priority,Type,Block Reason')
    expect(csv[1]).to eq('1,Title 1,CJ,Doing,Normal,Unassigned,""')
    expect(csv[2]).to eq('2,Title 2,CJ,Code Review,Normal,Unassigned,bad card')
  end

  it 'creates missing shepherds report' do
    expect(Kanban::Api).to receive(:cards_missing_tags).and_return([card1, card2])
    csv = Kanban::Report.cards_missing_tags.split("\n")
    expect(csv[0]).to eq('FogBugz ID,Title,Estimate,Lane,Priority,Type,Block Reason')
    expect(csv[1]).to eq('1,Title 1,3,Doing,Normal,Unassigned,""')
    expect(csv[2]).to eq('2,Title 2,4,Code Review,Normal,Unassigned,bad card')
  end
end
