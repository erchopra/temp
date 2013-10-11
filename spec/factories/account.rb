FactoryGirl.define do 
  factory :account do 
    name { Faker::Company.name }
    association :sales_rep, :factory => :user
    # sales_rep_id { 1+rand(User.all.count) }

    association :address
    account_type {AccountType.available_values.sample}
  end

  factory :pricing_tier do 
    name Faker::Lorem.word
    gross_profit 25
  end 

  factory :account_pricing_tier do 
    product { Product.available_values.sample }
    association :account
    association :pricing_tier
  end 

  factory :contact do 
    name { Faker::Name.name }
    position "Employee"
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    mobile_number nil
    fax_number nil
    primary_contact false
    billing_notifications false
    event_notifications true
    sms false

    association :account

    trait :primary do 
      primary_contact true
      billing_notifications true
      event_notifications true
      sms true
    end
  end

  factory :location do
    name { Faker::Lorem.word } 
    building_address_notes { Faker::Address.secondary_address } 

    association :contact
    association :account
    association :building

    factory :spot_location do
      location_type "spot"
      expected_participation { rand(50..150) }
      privacy { LocationPrivacy.available_values.sample }
      service_event_instructions { Faker::Lorem.paragraph }
      connectivity_instructions { Faker::Lorem.paragraph }
    end

    factory :delivery_location do
      location_type "delivery"
      delivery_event_instructions { Faker::Lorem.paragraph }
    end

  end
end