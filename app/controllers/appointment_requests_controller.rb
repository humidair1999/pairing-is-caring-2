class AppointmentRequestsController < ApplicationController
    def destroy
        appt = AppointmentRequest.find(params[:id])

        if current_user == appt.user
            if appt.destroy
                redirect_to dashboard_path, flash: { global: "Appointment request deleted." }
            else
                # TODO: store values in inputs so redirect doesn't wipe out user input
                redirect_to dashboard_path, flash: { global: "Error deleting appointment request." }
            end
        else
            redirect_to dashboard_path, flash: { global: "Unauthorized!" }
        end
    end
end
