# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    fog_bugz_id 1
    title "MyString"
    estimate 1
    lane "MyString"
    status "MyString"
    shepherd "MyString"
    board "MyString"
    comments "MyString"
  end
end
