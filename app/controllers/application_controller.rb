class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    include SessionsHelper

    private

        # confirms a logged-in user
        def logged_in_user
            unless logged_in?
                store_location

                redirect_to root_path, flash: { global: "Please log in." }
            end
        end

        # Confirms the correct user
        def correct_user
            @user = User.find(params[:id])

            unless current_user?(@user)
                redirect_to root_path, flash: { global: "Unauthorized user!" }
            end
        end
end
