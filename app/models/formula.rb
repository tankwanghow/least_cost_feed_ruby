class Formula < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :name, :batch_size, :cost
  validates_numericality_of :batch_size, greater_than_or_equal_to: 0.0
  validates_numericality_of :cost, greater_than_or_equal_to: 0.0
  validates_numericality_of :usage_per_day, greater_than_or_equal_to: 0.0
  validates_uniqueness_of :name, scope: :user_id

  has_many :formula_ingredients, -> { includes(:ingredient).order("actual desc") }, dependent: :destroy
  has_many :formula_nutrients, -> { includes(:nutrient).order("actual desc") }, dependent: :destroy
  has_many :formula_ingredients_histories, -> { includes(:ingredient).order("actual desc") }, dependent: :destroy

  accepts_nested_attributes_for :formula_ingredients, allow_destroy: true
  accepts_nested_attributes_for :formula_nutrients, allow_destroy: true

  attr_reader :prev_cost, :status

  def self.find_formulas terms=nil, page=1
    if terms.blank?
      User.current.formulas.page(page).order(:name)
    else
      User.current.formulas.where("name ilike ?", "%#{terms}%").order(:name).page(page)
    end
  end

  def calculate params=nil
    assign_attributes params if params
    n = User.current ? User.current.username :  random_word
    sol = DietGlpsol.solution_for_formula self, "#{n}_#{self.id}.mod"
    if sol[0]
      set_actual_to_zero
      put_soultion_to_formula sol[1]
    else
      @status = 'Error ' + sol[1]
    end
    count_cost_set_weight
    self.updated_at = DateTime.now
  end

  def savings
    @prev_cost ? self.cost - @prev_cost : 0
  end

  def self.create_like id
    like = Premix.find id
    a = like.dup
    a.name = like.name + " Copy #{DateTime.now.in_time_zone(User.current.time_zone).strftime('%Y%m%d%H%M%S')}"
    like.formula_ingredients.each do |t|
      a.formula_ingredients.build ingredient: t.ingredient, max: t.max, min: t.min, actual: t.actual, shadow: t.shadow, use: t.use
    end
    like.formula_nutrients.each do |t|
      a.formula_nutrients.build nutrient: t.nutrient, max: t.max, min: t.min, actual: t.actual, use: t.use
    end
    like.premix_ingredients.each do |t|
      a.premix_ingredients.build ingredient: t.ingredient, actual_usage: t.actual_usage, premix_usage: t.premix_usage
    end
    a.save!
    a
  end

  def me
    formula_nutrients.select { |t| t.nutrient.name == 'Metab. Energy' }.first.actual.round(2)
  end

  def cp
    formula_nutrients.select { |t| t.nutrient.name == 'Crude Protein' }.first.actual.round(2)
  end

  def log_to_history
    log_datetime = DateTime.now.to_s(:number)
    formula_ingredients.each do |t|
      formula_ingredients_histories.create! ingredient: t.ingredient, actual: t.actual, use: t.use, logged_at: log_datetime
    end
  end

  def set_current_formula_ingredients_from_history logged_at
    max = formula_ingredients_histories.where(logged_at: logged_at, formula: self).map { |t| t[:actual] }.max
    formula_ingredients_histories.where(logged_at: logged_at, formula: self).each do |t|
      f = formula_ingredients.find { |k| k.ingredient_id == t.ingredient_id }
      if t.actual == max
        f.min = t.actual - 0.000005
      else
        f.min = t.actual
      end
      f.use = t.use
      f.max = t.actual if t.actual <= 0.01
    end
    formula_nutrients.each { |t| t.use = false }
    self.cost = 0
  end

  def delete_history logged_at
    formula_ingredients_histories.where(logged_at: logged_at, formula: self).each { |t| t.destroy }
  end

private

  def count_cost_set_weight
    amt = 0
    formula_ingredients.each do |t|
      amt = amt + (t.actual * self.batch_size * t.ingredient.cost)
      t.weight = (t.actual * self.batch_size).round(4)
    end
    @prev_cost = self.cost
    self.cost = (amt/batch_size).round 4
  end

  def put_error_to_formula
    self.formula_ingredients.each do |t|
      t.actual = -1
      t.shadow = -1
    end

    self.formula_nutrients.each do |t|
      t.actual = -1
    end
  end

  def put_soultion_to_formula solution
    solution[:formula].each do |s|
      a = s.split(",")
      ingredient_id = a[0].split('_')[1].to_i
      actual = a[1].to_d
      shadow = a[2].to_d
      formula_ingredient = self.formula_ingredients.find { |t| t.ingredient_id == ingredient_id }
      formula_ingredient.actual = actual
      formula_ingredient.shadow = shadow
    end

    solution[:specs].each do |s|
      a = s.split(",")
      nutrient_id = a[0].split('_')[1].to_i
      actual = a[1].to_d
      formula_nutrient = self.formula_nutrients.find { |t| t.nutrient_id == nutrient_id }
      formula_nutrient.actual = actual
    end
    @status = 'Optimized'
  end

  def set_actual_to_zero
    self.formula_ingredients.each { |t| t.actual = 0 }
    self.formula_nutrients.each { |t| t.actual = 0 }
  end

  def random_word
    a = ""
    rand(10).times do
      a += %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)[rand(26)]
    end
    a
  end

  def floor(number, exp = 0)
    multiplier = 10 ** exp
    ((number * multiplier).floor).to_f/multiplier.to_f
  end
end
