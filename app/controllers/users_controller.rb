class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    
    def show 
    end 

    def new 
        @user = User.new
    end

    def edit 
    end 

    def index
        @users = User.all 
    end 

    def update 
        if @user.update(user_params)
            flash[:notice] = "Your account information was successfully updated"
            redirect_to articles_path
        else  
            render 'edit', status: :unprocessable_entity
        end
    end
    
    def create 
        @user = User.new(user_params)
        if @user.save 
            flash[:notice] = "Welcome to the Alpha Blog, you successfully sign up !"
            redirect_to articles_path
        else 
            render 'new', status: :unprocessable_entity
        end
    end

    def destroy 
        @user.destroy 
        session[:user_id] = nil if @user == current_user
        flash[:notice] = "Account and all associated article successfully deleted"
        redirect_to articles_path
    end

    private

    def set_user 
       @user = User.find(params[:id])
    end 

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user 
        if current_user != @user 
            flash[:alert] = "You can only update your account"
            redirect_to @user
        end
end
