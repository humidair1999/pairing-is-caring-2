FactoryGirl.define do
    factory :user do |f|
        f.username { Faker::Internet.user_name }
        f.email { Faker::Internet.email }
        f.password { Faker::Internet.password(3, 30) }
    end
end