class NutrientsController < ApplicationController

  def index
    @terms = params[:search] ? params[:search][:terms] : nil
    @nutrients = Nutrient.find_nutrients(@terms).page(params[:page])
  end

  def edit
    fetch_nutrient
  end

  def update
    fetch_nutrient
    if @nutrient.update(nutrient_params)
      flash[:success] = "Nutrient updated successfully."
      redirect_to edit_nutrient_path(@nutrient)
    else
      flash[:danger] = "Ooppps, fail to update Nutrient."
      render :edit
    end
  end

  def new
    @nutrient = Nutrient.new
  end

  def create
    @nutrient = Nutrient.new nutrient_params
    @nutrient.user_id = current_user.id
    if @nutrient.save
      flash[:success] = "Nutrient created successfully."
      redirect_to edit_nutrient_path(@nutrient)
    else
      flash[:danger] = "Ooppps, fail to update Nutrient."
      render :new
    end
  end

  def destroy
    fetch_nutrient
    @nutrient.destroy
    flash[:success] = "Nutrient destroyed successfully."
    redirect_to nutrients_path
  end

private

  def fetch_nutrient
    @nutrient = current_user.nutrients.find params[:id]
  end

  def nutrient_params
    params.require(:nutrient).permit(:name, :unit, :note)
  end

end
