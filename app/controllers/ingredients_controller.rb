class IngredientsController < ApplicationController

  def index
    @terms = params[:search] ? params[:search][:terms] : nil
    @ingredients = Ingredient.find_ingredients @terms
  end

  def update
    @ingredient = fetch_ingredient
    if @ingredient.update_attributes ingredient_params
      flash[:success] = "Ingredient updated successfully."
    else
      flash[:danger] = "Ooppps, fail to update Ingredient."
    end
    render :edit
  end

  def edit
    @ingredient = fetch_ingredient
  end 

  def new
    @ingredient = Ingredient.new
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
    @ingredient = fetch_ingredient
    @ingredient.destroy
    flash[:success] = "Ingredient destroyed successfully."
    redirect_to ingredients_path
  end

private

  def ingredient_params
    params.require(:ingredient).permit(:name, :cost, :status, :note, :batch_no)
  end

  def fetch_ingredient
    begin
      @ingredient = current_user.ingredients.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Record Not Found or Unauthorize!'
      redirect_to :root
    end
  end
end