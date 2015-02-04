class SessionsController < ApplicationController
    def new

    end

    def create
        p login_params[:username]

        user = User.find_by(username: login_params[:username])

        if user && user.authenticate(login_params[:password])
            # Log the user in and redirect to the user's show page.
            p 'LOGGED IN'
            p user

            redirect_to dashboard_path
        else
            redirect_to root_path, flash: { notice: "Sorry, your username or password wasn't correct!" }
        end
    end

    def destroy

    end

    private

        def login_params
            params.require(:session).permit(:username, :password)
        end
end
