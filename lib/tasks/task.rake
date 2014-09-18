require 'kanban'

namespace :task do
  desc "Processes done cards to support velocity calculations"
  task process_done: :environment do
    bot = Kanban::Crawler.new
    bot.snapshot_done_cards
  end

  desc "TODO"
  task upload: :environment do
    puts "upload"
  end

end

# cards = Kanban::Cards.missing_shepherd
# Notifications.no_shepherd(cards).deliver
#
# cards = Kanban::Cards.missing_size
# Notifications.no_size(cards).deliver
#
# cards = Kanban::Cards.done_in(5.weeks.ago..3.weeks.ago)
# analytics = CardAnalytics.new(cards)
# analytics.velocity
# analytics.cards_completed
# analytics.range
