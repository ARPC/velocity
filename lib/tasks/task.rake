require 'kanban'

namespace :task do
  desc "Processes done cards to support velocity calculations"
  task process_done: :environment do
    Rails.logger.info "Starting task:process_done"
    bot = Kanban::Crawler.new
    bot.snapshot_done_cards
    Rails.logger.info "Completing task:process_done"
  end

  desc "Notify the team about all the cards that are missing estimates"
  task notify_no_estimates: :environment do
    Rails.logger.info "Starting task:notify_no_estimates"
    cards = Kanban::Api.cards_missing_size
    NotificationMailer.no_estimate(cards).deliver unless cards.empty?
    Rails.logger.info "Completing task:notify_no_estimates"
  end

  desc "Notify the team about all the cards that are missing shepherds"
  task notify_no_shepherds: :environment do
    Rails.logger.info "Starting task:notify_no_shepherds"
    cards = Kanban::Api.cards_missing_tags
    NotificationMailer.no_shepherd(cards).deliver unless cards.empty?
    Rails.logger.info "Completing task:notify_no_shepherds"
  end

  desc "Provide an extract of every card and its lane"
  task extract: :environment do
    Rails.logger.info "Starting task:extract"
    csv = Kanban::Report.card_and_lane
    NotificationMailer.extract(csv).deliver
    Rails.logger.info "Completing task:extract"
  end
end
