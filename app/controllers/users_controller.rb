class UsersController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update, :dashboard]
    before_action :correct_user, only: [:update]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
          redirect_to user_path(@user.id), flash: { notice: "Thanks for signing up!" }
        else
            p @user.errors.messages
          flash[:notice] = "You entered some invalid data!"
          
          # TODO: store errors in flash and redirect instead of rendering new?
          render "new"
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(current_user)
    end

    def update
        @user = User.find(params[:id])

        if @user.update(user_params)
            redirect_to dashboard_path, flash: { notice: "Your information has been updated!" }
        else
            flash[:notice] = "You entered some invalid data!"

          render 'edit'
        end
    end

    def dashboard
        p 'hahahah'
    end

    private

        def user_params
            params.require(:user).permit(:username, :email, :password)
        end

        # Confirms a logged-in user
        def logged_in_user
            unless logged_in?
                redirect_to root_path, flash: { notice: "Please log in." }
            end
        end

        # Confirms the correct user
        def correct_user
            @user = User.find(params[:id])

            flash[:notice] = "Unauthorized user!"

            redirect_to(root_path) unless @user == current_user
        end
end