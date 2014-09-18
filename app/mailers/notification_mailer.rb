class NotificationMailer < ActionMailer::Base
  default from: "kanban@arpc.com"
  default to: "development@arpc.com"

  def no_size(cards)
    @cards = cards
    mail(subject: 'LeanKit: No Estimates!')
  end

  def no_shepherd(cards)
    @cards = cards
    mail(subject: 'LeanKit: No Shepherds!')
  end
end
