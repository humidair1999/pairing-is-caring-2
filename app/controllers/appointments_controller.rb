class AppointmentsController < ApplicationController
    before_action :logged_in_user, only: [:index, :new]

    def index
        @appointment = current_user.appointments.build

        @all_available_appointments = Appointment.offered.where.not(user: current_user)
    end

    def new
        @appointment = current_user.appointments.build

        @all_appointment_requests = Appointment.requested.where.not(user: current_user)
    end

    def create
        # TODO: associate new appointment with mentor entity
        @appointment = current_user.appointments.build(appointment_params)

        if user_type_is? 'mentor'
            @appointment.offer current_user
        elsif user_type_is? 'student'
            @appointment.request current_user
        end

        if @appointment.save
            redirect_to dashboard_path, flash: { global: "New available appointment created!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to new_appointment_path, flash: { validation: @appointment.errors.full_messages.first }
        end
    end

    def fulfill_offer
        @appointment = Appointment.find(params[:id])

        @appointment.fulfill({ student: current_user });

        if @appointment.save
            redirect_to dashboard_path, flash: { global: "Appointment scheduled!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to new_appointment_path, flash: { global: "Appointment no longer available!" }
        end
    end

    def cancel_offer
        @appointment = Appointment.find(params[:id])

        @appointment.cancel_offer current_user

        if @appointment.save
            redirect_to dashboard_path, flash: { global: "Appointment cancelled!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to new_appointment_path, flash: { global: "Appointment no longer available!" }
        end
    end

    def fulfill_request
        @appointment = Appointment.find(params[:id])

        @appointment.fulfill({ mentor: current_user });

        if @appointment.save
            redirect_to dashboard_path, flash: { global: "Appointment scheduled!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to new_appointment_path, flash: { global: "Appointment no longer available!" }
        end
    end

    def cancel_request
        @appointment = Appointment.find(params[:id])

        @appointment.cancel_request current_user

        if @appointment.save
            redirect_to dashboard_path, flash: { global: "Appointment cancelled!" }
        else
            # TODO: store values in inputs so redirect doesn't wipe out user input
            redirect_to new_appointment_path, flash: { global: "Appointment no longer available!" }
        end
    end

    # TODO: user should NOT be able to update user/student/mentor IDs
    def update

    end

    def destroy
        appt = Appointment.find(params[:id])

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

        def appointment_user_type_param
            permitted_params = params.require(:appointment).permit(:user_type)

            permitted_params[:user_type]
        end

        def user_type_is?(user_type)
            appointment_user_type_param && appointment_user_type_param == user_type
        end
end