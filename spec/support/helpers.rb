module Helpers
  def login_as user
    session[:user_id] = user ? (user.is_a?(User) ? user.id : create(:user).id) : nil
  end

  def add_dynamic_get_route route_hash
    begin
      _routes = Rails.application.routes
      _routes.disable_clear_and_finalize = true
      _routes.clear!
      Rails.application.routes_reloader.paths.each{ |path| load(path) }
      _routes.draw do
        get route_hash
      end
      ActiveSupport.on_load(:action_controller) { _routes.finalize! }
    ensure
      _routes.disable_clear_and_finalize = false
    end
  end
end