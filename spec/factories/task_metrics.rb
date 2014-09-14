# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_metric do
    leankit_id 1
    fog_bugz_id 1
    title "MyString"
    estimate 1
  end
end
