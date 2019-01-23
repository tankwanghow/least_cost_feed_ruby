class IngredientUsagesController < ApplicationController

  def index
    sql = "select i.id, i.name, sum(fi.actual * f.usage_per_day) as qty, i.cost" +
          "  from formulas f inner join formula_ingredients fi on f.id = fi.formula_id" +
          " inner join ingredients i on i.id = fi.ingredient_id" +
          " where f.usage_per_day > 0" +
          "   and fi.actual > 0" +
          " group by i.id, i.name, i.cost" +
          " order by sum(fi.actual * f.usage_per_day) * i.cost desc"
    @usages = ActiveRecord::Base.connection.execute(sql)
    @weight = @usages.inject(0) { |sum, hash| sum + hash["qty"].to_f }
    @cost = @usages.inject(0) { |sum, hash| sum + (hash["qty"].to_f * hash["cost"].to_f) }
  end

  def formula_params
    params.require(:formula).
      permit(:name, :batch_size, :note, :cost, :usage_per_day,
        formula_nutrients_attributes: [:id, :_destroy, :nutrient_id, :max, :min, :actual, :use],
        formula_ingredients_attributes: [:id, :_destroy, :ingredient_id, :ingredient_cost, :max_perc, :min_perc, :actual_perc, :shadow, :weight, :use])
  end
end
