class WelcomeController < ApplicationController
    def index
        @appointments = Appointment.all
    end
end
