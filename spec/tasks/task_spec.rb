require 'rails_helper'
require 'rake'

describe 'rake task' do
  before(:all) do
    Rake.application.rake_require('tasks/task')
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @card = Kanban::Card.new({
      'ExternalCardId' => 123,
      'Title' => 'My Card Title',
      'Size' => 31,
      'Tags' => 'Shepherd: CJ',
      'Lane' => 'Done',
      'PriorityText' => 'Normal',
      'TypeName' => 'Unassigned',
      'BlockReason' => ''
    })
  end

  context 'process_done' do
    it 'crawls done cards' do
      bot = double
      expect(Kanban::Crawler).to receive(:new).and_return(bot)
      expect(bot).to receive(:snapshot_done_cards)
      Rake.application.invoke_task('task:process_done')
    end
  end

  context 'notify_no_estimates' do
    it 'notifies the team with cards without estimates' do
      cards = [@card]
      mailer = double
      expect(Kanban::Api).to receive(:cards_missing_size).and_return(cards)
      expect(NotificationMailer).to receive(:no_estimate).with(cards).and_return(mailer)
      expect(mailer).to receive(:deliver)
      Rake.application.invoke_task('task:notify_no_estimates')
    end

    it 'does not send notification when all cards have estimates' do
      cards = []
      expect(Kanban::Api).to receive(:cards_missing_size).and_return(cards)
      expect(NotificationMailer).not_to receive(:no_estimate).with(cards)
      Rake.application.invoke_task('task:notify_no_estimates')
    end
  end

  context 'notify_no_shepherds' do
    it 'notifies the team with cards without shepherds' do
      cards = [@card]
      mailer = double
      expect(Kanban::Api).to receive(:cards_missing_shepherd).and_return(cards)
      expect(NotificationMailer).to receive(:no_shepherd).with(cards).and_return(mailer)
      expect(mailer).to receive(:deliver)
      Rake.application.invoke_task('task:notify_no_shepherds')
    end

    it 'does not send notification when all cards have shepherds' do
      cards = []
      expect(Kanban::Api).to receive(:cards_missing_shepherd).and_return(cards)
      expect(NotificationMailer).not_to receive(:no_shepherd).with(cards)
      Rake.application.invoke_task('task:notify_no_shepherds')
    end
  end
end
