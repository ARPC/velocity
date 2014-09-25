require 'base64'

class NotificationMailer < ActionMailer::Base
  default from: "kanban@arpc.com"
  default to: "trustonline@arpc.com"

  def no_estimate(cards)
    @cards = cards
    mail(subject: 'LeanKit: No Estimates!')
  end

  def no_shepherd(cards)
    @cards = cards
    mail(subject: 'LeanKit: No Shepherds!')
  end

  def extract(csv)
    attachments['extract.csv'] = { :data => Base64.encode64(csv), :encoding => 'base64' }
    mail(subject: 'LeanKit: Extract', to: 'j.yagerline@arpc.com', bcc: 'c.jekal@arpc.com')
  end
end
