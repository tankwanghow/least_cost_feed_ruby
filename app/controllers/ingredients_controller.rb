class IngredientsController < ApplicationController
  def new
    @ingredient = Ingredient.new
  end
end