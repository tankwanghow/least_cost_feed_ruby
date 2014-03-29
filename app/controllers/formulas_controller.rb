class FormulasController < ApplicationController
  def index
    @terms = params[:search] ? params[:search][:terms] : nil
    @formulas = Formula.find_formulas(@terms).page(params[:page])
  end

  def edit
    fetch_formula
  end

  def update
    fetch_formula
    if @formula.update(formula_params)
      flash[:success] = "Formula updated successfully."
    else
      flash[:danger] = "Ooppps, fail to update Formula."
    end
    render :edit
  end

  def new
    @formula = Formula.new
  end

  def create
    @formula = Formula.new formula_params
    @formula.user_id = current_user.id
    if @formula.save
      flash[:success] = "Formula created successfully."
      redirect_to formulas_path
    else
      flash[:danger] = "Ooppps, fail to update Formula."
      render :new
    end
  end

  def destroy
    fetch_formula
    @formula.destroy
    flash[:success] = "Formula destroyed successfully."
    redirect_to formulas_path
  end

private

  def fetch_formula
    @formula = current_user.formulas.find params[:id]
  end

  def formula_params
    params.require(:formula).
      permit(:name, :batch_size, :note, :cost, 
        formula_nutrients_attributes: [:id, :_destroy, :nutrient_id, :max, :min, :actual],
        formula_ingredients_attributes: [:id, :_destroy, :ingredient_id, :ingredient_cost, :max, :min, :actual])
  end
end
