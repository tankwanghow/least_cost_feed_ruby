class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to login_path, flash: { success: 'Yeah! Signed up successfully. Pending approval by System Administrator.' }
    else
      flash[:danger] = 'Ooppps! Failed to signup'
      render :new
    end
  end
  
private

  def user_params
    if current_user && !current_user.is_admin
      params.require(:user).permit(:username, :email, :name, :password, :password_confirmation)
    else
      params.require(:user).permit(:username, :email, :name, :password, :password_confirmation, :status, :is_admin)  
    end
  end

end
