require "rails_helper"

RSpec.describe User, :type => :model do
    describe "class functionality" do
        describe "validations" do
            it { should have_secure_password }

            it { should validate_presence_of(:username) }
            it { should validate_presence_of(:email) }
            it { should validate_presence_of(:password) }

            # apparently validate_length_of is only supported on master branch release
            #  of shoulda_matchers
            it { should ensure_length_of(:email).is_at_most(160) }
            it { should ensure_length_of(:username).is_at_most(30) }

            it { should have_many(:appointments) }
        end

        describe "User.digest" do
            it "should produce a bcrypt password" do
                fake_digest = User.digest('fake string')

                expect(fake_digest).to be_a(String)
                expect(fake_digest.length).to be > 10
            end
        end

        describe "User.new_token" do
            it "should produce a base64 string" do
                fake_token = User.new_token

                expect(fake_token).to be_a(String)
                expect(fake_token.length).to be > 10
            end
        end
    end

    describe "instance functionality" do
        let(:user) { FactoryGirl.create(:user) }

        it "has a valid factory" do
            expect(user).to be_valid
        end

        describe "remember" do
            it "assigns remember_token attribute to user" do
                user.remember

                expect(user.remember_token).not_to eq nil
            end

            it "updates remember_digest attribute on user" do
                user.remember

                expect(user.remember_digest).not_to eq nil
            end
        end

        describe "authenticated?" do
            it "should return false if the user doesn't have a remember_digest" do
                expect(user.authenticated?('intentionally false token')).to be_falsy
            end

            it "should return false if the passed remember_token doesn't match user's stored one" do
                user.remember

                expect(user.authenticated?('intentionally false token')).to be_falsy
            end

            it "should return true if the passed remember_token matches user's stored one" do
                user.remember

                expect(user.authenticated?(user.remember_token)).to be_truthy
            end
        end

        describe "forget" do
            before(:each) do
                user.remember
            end

            it "clears remember_digest attribute on user" do
                user.forget

                expect(user.remember_digest).to eq nil
            end
        end
    end
end