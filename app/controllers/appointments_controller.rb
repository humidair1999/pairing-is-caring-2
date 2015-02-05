class AppointmentsController < ApplicationController
    before_action :logged_in_user, only: [:new]

    def new
        @appointment = current_user.appointments.create
    end

    def create
        @appointment = current_user.appointments.create(appointment_params)

        if @appointment.save
            redirect_to dashboard_path, flash: { global: "New available appointment created!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to new_appointment_path, flash: { validation: @appointment.errors.full_messages.first }
        end
    end

    private

        def appointment_params
            params.require(:appointment).permit(:city, :scheduled_for, :notes)
        end
end