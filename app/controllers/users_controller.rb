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
        # my fulfilled appointments show up on my dashboard; others' show up on my dashboard only if
        #  I'm on the appointment; otherwise, they don't show up anywhere
        @all_my_fulfilled_appointments = Appointment.fulfilled_and_owned_by(current_user) +
                                            Appointment.fulfilled_as_student_and_not_owned_by(current_user) +
                                            Appointment.fulfilled_as_mentor_and_not_owned_by(current_user)

        # TODO: should really be done as part of db query, but our scope methods are making this hard
        @all_my_fulfilled_appointments.sort_by! { |appt| appt.scheduled_for }

        # created appointments should only be createable by admin
        @my_created_appointments = current_user.appointments.created

        # my requested appointments show up on my dashboard; others' show up on "find a mentor" page
        @my_requested_appointments = current_user.appointments.requested

        # my offered appointments show up on my dashboard; others' show up on "offer to mentor" page
        @my_offered_appointments = current_user.appointments.offered

        # my completed appointments show up on my dashboard; others' show up on my dashboard only if
        #  I was on the appointment; otherwise, they don't show up anywhere
        @my_completed_appointments = current_user.appointments.completed
    end

    private

        def user_params
            params.require(:user).permit(:username, :email, :password)
        end
end