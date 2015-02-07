class AppointmentsController < ApplicationController
    before_action :logged_in_user, only: [:index, :new]

    def index
        @all_available_appointments = Appointment.available.where.not(user: current_user)
    end

    def new
        @appointment = current_user.appointments.build

        @all_appointment_requests = AppointmentRequest.all
    end

    def create
        @appointment = current_user.appointments.build(appointment_params)

        if @appointment.save
            redirect_to dashboard_path, flash: { global: "New available appointment created!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to new_appointment_path, flash: { validation: @appointment.errors.full_messages.first }
        end
    end

    def destroy
        appt = Appointment.find(params[:id])

        p appt

        # TODO: abstract this into something less shitty
        if current_user == appt.user
            if appt.destroy
                redirect_to dashboard_path, flash: { global: "Appointment deleted." }
            else
                redirect_to dashboard_path, flash: { global: "Error deleting appointment." }
            end
        else
            redirect_to dashboard_path, flash: { global: "Unauthorized!" }
        end
    end

    private

        def appointment_params
            params.require(:appointment).permit(:city, :scheduled_for, :notes)
        end
end