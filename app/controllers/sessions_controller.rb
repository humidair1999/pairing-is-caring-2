class SessionsController < ApplicationController
    def create
        p login_params[:username]

        user = User.find_by(username: login_params[:username])

        if user && user.authenticate(login_params[:password])
            # Log the user in and redirect to the user's show page.
            p 'LOGGED IN'
            p user

            log_in user
            remember user

            redirect_back_or dashboard_path
        else
            redirect_to root_path, flash: { notice: "Sorry, your username or password wasn't correct!" }
        end
    end

    def destroy
        log_out if logged_in?

        redirect_to root_path, flash: { notice: "You've been logged out. Thanks for visiting!" }
    end

    private

        def login_params
            params.require(:session).permit(:username, :password)
        end
end
