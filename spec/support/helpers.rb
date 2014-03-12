module Helpers
  def login_as user
    session[:user_id] = user ? (user.is_a?(User) ? user.id : create(:user).id) : nil
  end

  def permitted_params params, keys
    keys.map! { |t| t.to_s }
    params.select do |k, v|
      keys.include? k.to_s 
    end.map do |k, v|
      [k, [TrueClass, FalseClass].include?(v.class) ? v : v.to_s ]
    end.to_h
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