require 'ffaker'

FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }    
    name { Faker::Name.name }
    password "secret"
    password_confirmation "secret"
    is_admin false
    
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