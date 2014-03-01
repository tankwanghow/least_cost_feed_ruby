class SessionsController < ApplicationController
  skip_before_action :login_required
  
  def new
    redirect_logged_in_user if current_user
  end

  def create
    if current_user
      redirect_logged_in_user
    else
      @user = User.find_by_username params[:session][:username]
      if !@user
        redirect_invalid_user
      else
        if !@user.authenticate(params[:session][:password])
          redirect_invalid_user
        else
          if @user.status == 'pending'
            redirect_pending_user
          else
            session[:user_id] = @user.id
            redirect_to :dashboard, flash: { success: "Logged in successfully." }
          end
        end
      end
    end
  end

  def destroy
    session.clear if current_user
    redirect_to :root, notice: "Logged Out."
  end

  private

  def redirect_logged_in_user
    redirect_to :back, notice: "Already logged in."
  end

  def redirect_pending_user
    redirect_to :root, flash: { notice: "Your account is pending approval." }
  end

  def redirect_invalid_user
    redirect_to :login, flash: { error: "Invalid username or password." }
  end
end
