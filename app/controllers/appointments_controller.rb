class AppointmentsController < ApplicationController
    before_action :logged_in_user, only: [:new]

    def new

    end
end