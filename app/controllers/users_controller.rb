class UsersController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update, :dashboard]
    before_action :correct_user, only: [:update]

    # TODO: wipe out flashes before/after actions?

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            redirect_to root_path, flash: { global: "Thanks for signing up! Please log in." }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to register_path, flash: { validation: @user.errors.full_messages.first }
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = current_user
    end

    def update
        @user = User.find(params[:id])

        if @user.update(user_params)
            redirect_to dashboard_path, flash: { global: "Your information has been updated!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to settings_path, flash: { validation: @user.errors.full_messages.first }
        end
    end

    def dashboard
        # TODO: what's going on the fuckin' dashboard?!
        @my_requested_appointments = current_user.appointments.requested
        @my_offered_appointments = current_user.appointments.offered
        @my_fulfilled_appointments = current_user.appointments.fulfilled
        @my_completed_appointments = current_user.appointments.completed
    end

    private

        def user_params
            params.require(:user).permit(:username, :email, :password)
        end
end