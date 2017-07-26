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
    if User.count < 200
      @user.status = 'active'
    else
      @user.status = 'pending'
    end
    if @user.save
      if @user.status == 'active'
        flash[:success] = 'Yeah! Signed up successfully. Please Login.'
      else
        flash[:success] = 'Yeah! Signed up successfully. Pending approval by System Administrator.'
      end
      redirect_to login_path
    else
      flash[:danger] = 'Ooppps! Failed to signup'
      render :new
    end
  end

  def lock
    fetch_user params[:user_id]
    @user.status = 'locked'
    if @user.save
      flash[:warning] = "Locked #{@user.name}"
    else
      flash[:danger] = "Fail to Lock #{@user.name}. #{@user.errors}"
    end
    redirect_to users_path
  end

  def activate
    fetch_user params[:user_id]
    @user.status = 'active'
    if @user.save
      flash[:success] = "Activated #{@user.name}"
    else
      flash[:danger] = "Fail to Activate #{@user.name}. #{@user.errors}"
    end
    redirect_to users_path
  end

  def destroy
    fetch_user
    @user.destroy
    flash[:success] = "User destroyed successfully."
    redirect_to users_path
  end

private

  def fetch_user id=params[:id]
    if id.to_i == current_user.try(:id) || current_user.is_admin
      @user = User.find(id.to_i)
    else
      redirect_to :back, flash: { danger: "Cannot edit other user." }
    end
  end

  def user_params
    if current_user.try(:is_admin) && current_user.id == @user.id
      params.require(:user).permit(:username, :email, :name, :password, :password_confirmation, :country, :time_zone, :weight_unit, :is_admin, :status)
    elsif !current_user.try(:is_admin)
      params.require(:user).permit(:username, :email, :name, :password, :password_confirmation, :country, :time_zone, :weight_unit)
    else
      params.require(:user).permit(:password, :password_confirmation, :status, :is_admin)
    end
  end

end
