FactoryGirl.define do
  factory :issue do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    priority { ["High", "Low", "Normal"].sample }

    association :assignee, factory: :user
    association :assigner, factory: :user
    association :subject, factory: [:vendor, :account, :event].sample
  end
  
end
