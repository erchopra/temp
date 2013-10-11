FactoryGirl.define do 
  factory :user do 
    username { Faker::Name.first_name }
    email { Faker::Internet.email }

    password "new_passwords"
    role "admin"
    
    before(:create) do |user| 
      user.skip_confirmation!
    end
  end
end

