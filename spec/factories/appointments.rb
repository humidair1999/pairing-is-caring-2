FactoryGirl.define do
    factory :appointment do |f|
        f.city { ["san francisco", "chicago", "new york city"].sample }
        f.scheduled_for { Faker::Time.forward(12, :evening) }
        f.user { FactoryGirl.create(:user) }
    end
end