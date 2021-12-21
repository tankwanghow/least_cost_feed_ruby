require './app/views/formulas/formula_pdf.rb'

class FormulasController < ApplicationController

  def delete_history
    fetch_formula
    @formula.delete_history params[:logged_at]
    flash[:danger] = "Formula deleted #{params[:logged_at]}"
    render :edit
  end

  def log
    fetch_formula
    if @formula
      @formula.log_to_history
      redirect_to edit_formula_path(@formula)
    else
      flash[:danger] = "Ooppps, fail to log Formula."
      redirect_to edit_formula_path(@formula)
    end
  end

  def set_history
    fetch_formula
    if @formula
      @formula.set_current_formula_ingredients_from_history params[:logged_at]
      flash.now[:success] = "Formula changed to #{params[:logged_at]}"
      render :edit
    end
  end

  def update_daily_usage
    fetch_formula
    @formula.update_attributes(usage_per_day: params[:usage]) if @formula
  end

  def show
    fetch_formula
    respond_to do |format|
      format.pdf do
        pdf = FormulaPdf.new(@formula, view_context)
        send_data pdf.render, filename: "formula_#{@formula.name}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def index
    @terms = params[:search] ? params[:search][:terms] : nil
    @formulas = Formula.find_formulas(@terms).page(params[:page])
  end

  def edit
    fetch_formula
  end

  def update
    fetch_formula
    params[:commit] == 'Calculate' ? calculate : up_date
  end

  def new
    @formula = Formula.new
  end

  def create
    if params[:commit] == 'Calculate'
      calculate
    else
      kreate
    end
  end

  def destroy
    fetch_formula
    @formula.destroy
    flash[:success] = "Formula destroyed successfully."
    redirect_to formulas_path
  end

private

  def calculate
    @formula = Formula.new unless @formula
    @formula.calculate formula_params
    if @formula.status == "Optimized"
      flash[:info] = @formula.status
    else
      flash[:danger] = @formula.status
    end
    if @formula.new_record?
      render :new
    else
      render :edit
    end
  end

  def kreate
    @formula = Formula.new formula_params
    @formula.user_id = current_user.id
    if @formula.save
      flash[:success] = "Formula created successfully."
      redirect_to edit_formula_path(@formula)
    else
      flash[:danger] = "Ooppps, fail to update Formula."
      render :new
    end
  end

  def up_date
    if @formula.update(formula_params)
      flash[:success] = "Formula updated successfully."
      @premix.premix_ingredients.destroy_all
      redirect_to edit_formula_path(@formula)
    else
      flash[:danger] = "Ooppps, fail to update Formula."
      render :edit
    end
  end

  def fetch_formula
    @formula = current_user.formulas.find params[:id]
    @premix = Premix.find @formula.id
  end

  def formula_params
    params.require(:formula).
      permit(:name, :batch_size, :note, :cost, :usage_per_day,
        formula_nutrients_attributes: [:id, :_destroy, :nutrient_id, :max, :min, :actual, :use],
        formula_ingredients_attributes: [:id, :_destroy, :ingredient_id, :ingredient_cost, :max_perc, :min_perc, :actual_perc, :shadow, :weight, :use])
  end
end
