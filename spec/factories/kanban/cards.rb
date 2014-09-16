# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    id 1
    title "my card title"
    external_card_id 123
    size 13
    last_move Date.civil(2014, 9, 11)
  end
end
