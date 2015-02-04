class UsersController < ApplicationController
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

    private

        def user_params
            params.require(:user).permit(:username, :email, :password)
        end
end