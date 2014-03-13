require 'ffaker'

FactoryGirl.define do
  
  factory :ingredient do
    user { create :user }
    name { Faker::Name.name }
    cost { rand(99999)/100 }
    batch_no { rand(2014123111).to_s }
    note { Faker::Lorem.sentence }
    status { ['pending', 'using', 'finished', 'canceled'][rand(4)] }

    factory :invalid_ingredient do
      status { nil }
      cost { nil }
    end
  end

  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }    
    name { Faker::Name.name }
    password "secret"
    password_confirmation "secret"
    is_admin { false }
    currency { ["USD", "MYR", "EUR", "SGD"][rand(4)] }
    time_zone { ["UTC", "Kuala Lumpur", "London", "Hong Kong"][rand(4)] }
    weight_unit { ["Kg", "lb", "Mt"][rand(3)] }

    factory :admin_user do
      is_admin true
    end

    factory :invalid_user do
      password_confirmation { 'mama' }
      password { 'papa' }
    end

    factory :active_user do
      status { :active }
    end
  end

end