class Formula < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :name, :batch_size, :cost
  validates_numericality_of :batch_size, greater_than_or_equal_to: 0.0
  validates_numericality_of :cost, greater_than_or_equal_to: 0.0
  validates_uniqueness_of :name, scope: :user_id

  has_many :formula_ingredients, -> { includes(:ingredient).order("actual desc") }, dependent: :destroy
  has_many :formula_nutrients, -> { includes(:nutrient).order("actual desc") }, dependent: :destroy

  accepts_nested_attributes_for :formula_ingredients, allow_destroy: true
  accepts_nested_attributes_for :formula_nutrients, allow_destroy: true

  attr_reader :prev_cost

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
    DietGlpsol.solution_for_formula self, "#{n}_#{self.id}.mod"
    count_cost_set_weight
    self.updated_at = DateTime.now
  end

  def count_cost_set_weight
    amt = 0
    formula_ingredients.each do |t|
      amt = amt + (t.actual * self.batch_size * t.ingredient.cost)
      t.weight = (t.actual * self.batch_size).round(4)
    end
    @prev_cost = self.cost
    self.cost = (amt/batch_size).round 4
  end

  def savings
    @prev_cost ? self.cost - @prev_cost : 0
  end

private

  def random_word
    a = ""
    rand(10).times do 
      a += %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)[rand(26)]
    end
    a
  end
end
