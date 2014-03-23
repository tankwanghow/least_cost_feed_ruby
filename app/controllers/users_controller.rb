class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  
  def index
    if current_user.is_admin
      @terms = params[:search] ? params[:search][:terms] : nil
      @users = User.find_users(@terms).page(params[:page])
    else
      redirect_to :root, flash: { danger: "Unauthorize access!" }
    end
  end

  def new
    @user = User.new
  end

  def edit
    fetch_user
  end

  def update
    fetch_user
    if @user.update user_params
      flash[:success] = "#{@user.name} Profile updated successfully. Will be reflect next login."
      redirect_to root_path
    else
      flash[:danger] = "Failed to updated User Profile."
      render :edit
    end
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

  def fetch_user
    if params[:id].to_i == current_user.try(:id) || current_user.is_admin
      @user = User.find(params[:id].to_i)
    else
      redirect_to :back, flash: { danger: "Cannot edit other user." }
    end
  end

  def user_params
    if current_user.try(:is_admin) && current_user.id == @user.id
      params.require(:user).permit(:username, :email, :name, :password, :password_confirmation, :currency, :time_zone, :weight_unit, :is_admin, :status)
    elsif !current_user.try(:is_admin)
      params.require(:user).permit(:username, :email, :name, :password, :password_confirmation, :currency, :time_zone, :weight_unit)
    else
      params.require(:user).permit(:password, :password_confirmation, :status, :is_admin)
    end
  end

end
