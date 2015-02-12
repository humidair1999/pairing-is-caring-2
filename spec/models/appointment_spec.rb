require "rails_helper"

RSpec.describe Appointment, :type => :model do
    describe "class functionality" do
        describe "validations" do
            # apparently validate_inclusion_of is only supported on master branch release
            #  of shoulda_matchers
            it { should ensure_inclusion_of(:city).in_array(["san francisco", "chicago", "new york city"]) }

            it { should belong_to(:user) }
            it { should validate_presence_of(:user) }

            it { should belong_to(:mentor) }
            it { should belong_to(:student) }

            it 'fails validation when scheduled_for is invalid datetime' do
                fake_user = User.new
                appt = Appointment.new(user: fake_user, city: 'chicago', scheduled_for: 'not a fucking datetime')

                appt.valid?

                expect(appt.errors.messages.count).to eq 1
                expect(appt.errors.messages.has_key?(:scheduled_for)).to be_truthy
            end

            it 'passes validation when scheduled_for is valid datetime' do
                fake_user = User.new
                appt = Appointment.new(user: fake_user, city: 'chicago', scheduled_for: '2015-02-14T02:45:32')

                expect(appt.valid?).to be_truthy
            end
        end
    end
end