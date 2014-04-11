require 'ffaker'

FactoryGirl.define do

  factory :formula_nutrient do
    formula { create :formula }
    nutrient { create :nutrient }
    max { rand(999) }
    min { rand(999) }
    actual { rand(999) }
  end

  factory :formula_ingredient do
    formula { create :formula }
    ingredient { create :ingredient }
    max { rand(999) }
    min { rand(999) }
    actual { rand(999) }
    shadow { rand(999) }
    weight { rand(999) }
  end

  factory :formula do
    user { create :user }
    name { Faker::Name.name }
    cost { rand(9999) }
    batch_size { rand(9999) }
    note { Faker::Lorem.sentence }

    factory :invalid_formula do
      name { nil }
    end
  end

  factory :ingredient_composition do
    ingredient { create :ingredient }
    nutrient   { create :nutrient }
    value      { rand(999999)/100 }
  end

  factory :nutrient do
    user { create :user }
    name { Faker::Name.name }
    unit { Faker::Name.name }
    category { ['private', 'public', 'sample'][rand(3)] }
    note { Faker::Lorem.sentence }

    factory :invalid_nutrient do
      name { nil }
      unit { nil }
    end
  end
  
  factory :ingredient do
    user { create :user }
    name { Faker::Name.name }
    package_weight { rand(444) }
    cost { rand(99999)/100 }
    note { Faker::Lorem.sentence }
    category { ['private', 'public', 'sample'][rand(3)] }
    status { ['pending', 'using', 'finished', 'canceled'][rand(4)] }

    factory :invalid_ingredient do
      status { nil }
      cost { nil }
    end
  end

  factory :user do
    username { Faker::Internet.user_name + rand(999).to_s }
    email { Faker::Internet.email }    
    name { Faker::Name.name }
    password "secret"
    password_confirmation "secret"
    is_admin { false }
    country { ["US", "Mynmar", "Demark", "Malaysia"][rand(4)] }
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