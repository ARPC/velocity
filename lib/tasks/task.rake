require 'kanban'

namespace :task do
  desc "Processes done cards to support velocity calculations"
  task process_done: :environment do
    Rails.logger.info "Starting task:process_done"
    bot = Kanban::Crawler.new
    bot.snapshot_done_cards
    Rails.logger.info "Completing task:process_done"
  end

  namespace :notify do
    desc "Notify the team about all the cards that are missing estimates"
    task no_estimates: :environment do
      Rails.logger.info "Starting task:notify:no_estimates"
      cards = Kanban::Api.cards_missing_size
      NotificationMailer.no_estimate(cards).deliver unless cards.empty?
      Rails.logger.info "Completing task:notify:no_estimates"
    end

    desc "Notify the team about all the cards that are missing shepherds"
    task no_shepherds: :environment do
      Rails.logger.info "Starting task:notify:no_shepherds"
      cards = Kanban::Api.cards_missing_tags
      NotificationMailer.no_shepherd(cards).deliver unless cards.empty?
      Rails.logger.info "Completing task:notify:no_shepherds"
    end

    desc "Provide an extract of every card and its lane"
    task extract: :environment do
      Rails.logger.info "Starting task:notify:extract"
      csv = Kanban::Report.card_and_lane
      NotificationMailer.extract(csv).deliver
      Rails.logger.info "Completing task:notify:extract"
    end

    desc "Send all notification tasks"
    task all: [:environment, :no_estimates, :no_shepherds, :extract] do
      Rails.logger.info "Starting task:notify:all"
      Rails.logger.info "Completing task:notify:all"
    end
  end
end
