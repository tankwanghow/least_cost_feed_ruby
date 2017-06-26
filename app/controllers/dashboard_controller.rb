class DashboardController < ApplicationController

  def index
    @formulas_count = current_user.formulas.count
    @ingredients_count = current_user.ingredients.count
    @nutrients_count = current_user.nutrients.count
  end

end
