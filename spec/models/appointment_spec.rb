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

            # TODO: more thorough validation checking on datetime

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

    describe "instance functionality" do
        let(:appointment) { FactoryGirl.create(:appointment) }

        it "has a valid factory" do
            expect(appointment).to be_valid
        end

        describe "state change event methods" do
            describe "request" do
                it "attaches valid student to appointment and changes state if it doesn't currently have one" do
                    student = FactoryGirl.create(:user)

                    appointment.request student

                    expect(appointment.student_id).to eq student.id
                    expect(appointment.student).to eq student
                    expect(appointment.requested?).to be_truthy
                end

                it "doesn't attach invalid student to appointment or change state if it doesn't currently have one" do
                    student = User.create

                    appointment.request student

                    expect(appointment.student_id).to eq nil
                    expect(appointment.student).to eq nil
                    expect(appointment.requested?).to be_falsy
                end

                it "doesn't attach valid student to appointment or change state if it does currently have one" do
                    student = FactoryGirl.create(:user)
                    student2 = FactoryGirl.create(:user)

                    appointment.request student

                    appointment.request student2

                    expect(appointment.student_id).to eq student.id
                    expect(appointment.student).to eq student
                    expect(appointment.requested?).to be_truthy
                end
            end

            describe "fulfill_request" do
                it "attaches valid mentor to requested appointment and changes state if it doesn't currently have one" do
                    student = FactoryGirl.create(:user)
                    mentor = FactoryGirl.create(:user)

                    appointment.request student

                    appointment.fulfill_request mentor

                    expect(appointment.mentor_id).to eq mentor.id
                    expect(appointment.mentor).to eq mentor
                    expect(appointment.fulfilled?).to be_truthy
                end

                it "doesn't attach invalid mentor to requested appointment or change state if it doesn't currently have one" do
                    student = FactoryGirl.create(:user)
                    mentor = User.create

                    appointment.request student

                    appointment.fulfill_request mentor

                    expect(appointment.mentor_id).to eq nil
                    expect(appointment.mentor).to eq nil
                    expect(appointment.fulfilled?).to be_falsy
                end

                it "doesn't attach valid mentor to requested appointment or change state if it does currently have one" do
                    student = FactoryGirl.create(:user)
                    mentor = FactoryGirl.create(:user)
                    mentor2 = FactoryGirl.create(:user)

                    appointment.request student

                    appointment.fulfill_request mentor

                    appointment.fulfill_request mentor2

                    expect(appointment.mentor_id).to eq mentor.id
                    expect(appointment.mentor).to eq mentor
                    expect(appointment.fulfilled?).to be_truthy
                end
            end

            describe "cancel_request" do
                it "removes student from fulfilled appointment and changes state if student was requester" do
                    student = FactoryGirl.create(:user)
                    mentor = FactoryGirl.create(:user)

                    appointment.request student

                    appointment.fulfill_request mentor

                    appointment.cancel_request student

                    expect(appointment.student_id).to eq nil
                    expect(appointment.student).to eq nil
                    expect(appointment.offered?).to be_truthy
                end

                it "doesn't remove student from fulfilled appointment or change state if student wasn't requester" do
                    student = FactoryGirl.create(:user)
                    student2 = FactoryGirl.create(:user)
                    mentor = FactoryGirl.create(:user)

                    appointment.request student

                    appointment.fulfill_request mentor

                    appointment.cancel_request student2

                    expect(appointment.student_id).to eq student.id
                    expect(appointment.student).to eq student
                    expect(appointment.offered?).to be_falsy
                end
            end

            describe "offer" do
                it "attaches valid mentor to appointment and changes state if it doesn't currently have one" do
                    mentor = FactoryGirl.create(:user)

                    appointment.offer mentor

                    expect(appointment.mentor_id).to eq mentor.id
                    expect(appointment.mentor).to eq mentor
                    expect(appointment.offered?).to be_truthy
                end

                it "doesn't attach invalid student to appointment or change state if it doesn't currently have one" do
                    mentor = User.create

                    appointment.offer mentor

                    expect(appointment.mentor_id).to eq nil
                    expect(appointment.mentor).to eq nil
                    expect(appointment.offered?).to be_falsy
                end

                it "doesn't attach valid student to appointment or change state if it does currently have one" do
                    mentor = FactoryGirl.create(:user)
                    mentor2 = FactoryGirl.create(:user)

                    appointment.offer mentor

                    appointment.offer mentor2

                    expect(appointment.mentor_id).to eq mentor.id
                    expect(appointment.mentor).to eq mentor
                    expect(appointment.offered?).to be_truthy
                end
            end

            describe "fulfill_offer" do
                it "attaches valid student to offered appointment and changes state if it doesn't currently have one" do
                    student = FactoryGirl.create(:user)
                    mentor = FactoryGirl.create(:user)

                    appointment.offer mentor

                    appointment.fulfill_offer student

                    expect(appointment.student_id).to eq student.id
                    expect(appointment.student).to eq student
                    expect(appointment.fulfilled?).to be_truthy
                end

                it "doesn't attach invalid student to offered appointment or change state if it doesn't currently have one" do
                    student = User.create
                    mentor = FactoryGirl.create(:user)

                    appointment.offer mentor

                    appointment.fulfill_offer student

                    expect(appointment.student_id).to eq nil
                    expect(appointment.student).to eq nil
                    expect(appointment.fulfilled?).to be_falsy
                end

                it "doesn't attach valid student to offered appointment or change state if it does currently have one" do
                    student = FactoryGirl.create(:user)
                    student2 = FactoryGirl.create(:user)
                    mentor = FactoryGirl.create(:user)

                    appointment.offer mentor

                    appointment.fulfill_offer student

                    appointment.fulfill_offer student2

                    expect(appointment.student_id).to eq student.id
                    expect(appointment.student).to eq student
                    expect(appointment.fulfilled?).to be_truthy
                end
            end
        end
    end
end