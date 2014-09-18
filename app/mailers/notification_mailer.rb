require 'csv'
require 'base64'

class NotificationMailer < ActionMailer::Base
  default from: "kanban@arpc.com"
  default to: "development@arpc.com"

  def no_estimate(cards)
    @cards = cards
    mail(subject: 'LeanKit: No Estimates!')
  end

  def no_shepherd(cards)
    @cards = cards
    mail(subject: 'LeanKit: No Shepherds!')
  end

  def extract(cards)
    @cards = cards

    csv = CSV.generate do |csv|
      csv << ['FogBugzId', 'Lane']
      cards.each do |card|
        csv << [card.external_card_id, card.lane]
      end
    end

    attachments['extract.csv'] = { :data=> Base64.encode64(csv), :encoding => 'base64' }
    mail(subject: 'LeanKit: Extract', to: 'j.yagerline@arpc.com')
  end
end
