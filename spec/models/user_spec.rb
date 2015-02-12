require "rails_helper"

RSpec.describe User, :type => :model do
    it { should have_secure_password }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    # apparently validate_length_of is only supported on master branch release
    #  of shoulda_matchers
    it { should ensure_length_of(:email).is_at_most(160) }
    it { should ensure_length_of(:username).is_at_most(30) }

    it { should have_many(:appointments) }

    it "has a valid factory" do
        expect(FactoryGirl.create(:user)).to be_valid
    end

    # it "orders by last name" do
    #     lindeman = User.create!(first_name: "Andy", last_name: "Lindeman")
    #     chelimsky = User.create!(first_name: "David", last_name: "Chelimsky")

    #     expect(User.ordered_by_last_name).to eq([chelimsky, lindeman])
    # end
end