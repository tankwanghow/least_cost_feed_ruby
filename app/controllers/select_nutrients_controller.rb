class SelectNutrientsController < ApplicationController
  before_action :fetch_nutrients

  def new
    
  end

  def create
  
  end

private
  
  def fetch_nutrients
    @nutrients = current_user.nutrients
  end
end
