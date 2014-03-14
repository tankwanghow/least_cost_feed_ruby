class SessionsController < ApplicationController
  skip_before_action :login_required

  def create
    if current_user
      redirect_to :back, flash: { warning: "Already logged in." }
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
            Time.zone = @user.time_zone
            flash[:success] = "Logged in successfully."
            redirect_to_target_or_default :dashboard
          end
        end
      end
    end
  end

  def destroy
    session.clear if current_user
    redirect_to :root, flash: { success: "Logged Out." }
  end

  private

  def redirect_logged_in_user
    flash[:warning] = "Already logged in."
    redirect_to_target_or_default :dashboard
  end

  def redirect_pending_user
    redirect_to :root, flash: { warning: "Your account is pending approval." }
  end

  def redirect_invalid_user
    redirect_to :login, flash: { danger: "Invalid username or password." }
  end
end
