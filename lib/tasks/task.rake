require 'leankitkanban'

namespace :task do
  desc "TODO"
  task process: :environment do
    puts "process"
    response = LeanKitKanban::Board.find(46341228)

    response[0]['Lanes'].each do |lane|
      p lane['Title']
      lane['Cards'].each do |card|
        #p card
        p "Lane: #{lane['Title']}|Title: #{card['Title']}|External ID: #{card['ExternalCardID']}|Size: #{card['Size']}"
      end
    end
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
#
# bot = Kanban::Crawler.new
# bot.snapshot_done_cards
