require "rails_helper"

RSpec.describe SessionsHelper, :type => :helper do
    describe "module methods" do
        let(:user) { FactoryGirl.create(:user) }

        describe "log_in" do
            it "sets session.user_id for the user" do
                helper.log_in user

                expect(session[:user_id]).to eq user.id
            end
        end

        describe "remember" do
            it "sets permanent cookie values for the user" do
                helper.remember user

                expect(cookies.signed[:user_id]).to eq user.id
                expect(cookies[:remember_token]).not_to eq nil
            end
        end

        describe "forget" do
            it "sets permanent cookie values for the user" do
                helper.forget user

                expect(cookies.signed[:user_id]).to eq nil
                expect(cookies[:remember_token]).to eq nil
            end
        end

        describe "current_user" do
            it "returns the current user when session contains a valid user id" do
                helper.log_in user

                expect(helper.current_user).to eq user
            end

            it "returns the current user and logs user in when cookie contains a valid user id and session does not" do
                helper.remember user

                current_user = helper.current_user

                expect(session[:user_id]).to eq current_user.id
                expect(current_user).to eq user
            end

            it "returns nil when neither session nor cookie is set for user" do
                expect(helper.current_user).to eq nil
            end
        end

        describe "current_user?" do
            it "returns true when passed-in session user equals current_user" do
                helper.log_in user

                expect(helper.current_user?(user)).to be_truthy
            end

            it "returns true when passed-in cookie user equals current_user" do
                helper.remember user

                expect(helper.current_user?(user)).to be_truthy
            end

            it "returns false when user has not been logged in or remembered" do
                expect(helper.current_user?(user)).to be_falsy
            end
        end

        describe "logged_in?" do
            it "returns true when current_user is logged in" do
                helper.log_in user

                expect(helper.logged_in?).to be_truthy
            end

            it "returns true when current_user is remembered" do
                helper.remember user

                expect(helper.logged_in?).to be_truthy
            end

            it "returns false when current_user is not set" do
                expect(helper.logged_in?).to be_falsy
            end
        end

        describe "log_out" do
            it "deletes session and unsets current_user" do
                helper.log_in user
                helper.remember user

                helper.log_out

                expect(session[:user_id]).to eq nil
                expect(helper.current_user).to eq nil
            end
        end
    end
end