class IngredientsController < ApplicationController

  def index
    @terms = params[:search] ? params[:search][:terms] : nil
    @ingredients = Ingredient.find_ingredients(@terms).page(params[:page])
  end

  def update
    fetch_ingredient
    if @ingredient.update(ingredient_params)
      flash[:success] = "Ingredient updated successfully."
    else
      flash[:danger] = "Ooppps, fail to update Ingredient."
    end
    render :edit
  end

  def edit
    fetch_ingredient
  end 

  def new
    @ingredient = Ingredient.new_with_ingredient_compositions
  end

  def create
    @ingredient = Ingredient.new ingredient_params
    @ingredient.user_id = current_user.id
    if @ingredient.save
      flash[:success] = "Ingredient created successfully."
      redirect_to ingredients_path
    else
      flash[:danger] = "Ooppps, fail to create Ingredient."
      render :new
    end
  end

  def destroy
    fetch_ingredient
    @ingredient.destroy
    flash[:success] = "Ingredient destroyed successfully."
    redirect_to ingredients_path
  end

private

  def ingredient_params
    params.require(:ingredient).permit(:name, :cost, :status, :note, :batch_no, ingredient_compositions_attributes: [:nutrient_id, :value])
  end

  def fetch_ingredient
    @ingredient = current_user.ingredients.find(params[:id])
  end
end