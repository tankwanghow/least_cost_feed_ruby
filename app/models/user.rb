require 'csv'

class User < ActiveRecord::Base
  has_secure_password
  include SentientUser
  validates :username, uniqueness: true
  validates :name, :username, :time_zone, :country, :weight_unit, :status, :email , presence: true
  has_many :ingredients
  has_many :nutrients
  has_many :formulas

  after_save :add_sample_nutrients_and_ingredients

  def self.find_users terms=nil, page=1
    if terms.blank?
      User.all.page(page).order(:name)
    else
      User.where("username || name || email || status ilike ?", "%#{terms}%").page(page).order(:name)
    end
  end

private

  def add_sample_nutrients_and_ingredients
    path = 'app/models/sample_data/'
    env = Rails.env == 'test' ? '_test' : ''
    if changes["status"] && changes["status"][1] == 'active'
      CSV.foreach(File.expand_path("app/models/sample_data/nutrients#{env}.csv"), headers: true, col_sep: ',') do |d|
        Nutrient.create! name: d["Nutrient"], unit: d['Unit'], category: 'sample', user_id: self.id
      end

      CSV.foreach(File.expand_path("app/models/sample_data/ingredients#{env}.csv"), headers: true, col_sep: ',') do |d|
        Ingredient.create! name: d["Name"], cost: d['Price'], category: 'sample', user_id: self.id
      end

      CSV.foreach(File.expand_path("app/models/sample_data/ingredient_compositions#{env}.csv"), headers: true, col_sep: ',') do |d|
        i = Ingredient.find_by_name_and_user_id(d['Ingredient'], self.id)
        d.each do |t|
          n = Nutrient.find_by_name_and_user_id(t[0], self.id) if t[0] != "Ingredient"
          IngredientComposition.create! nutrient_id: n.id, ingredient_id: i.id, value: t[1] if t[1] && n && i
        end
      end
    end
  end

end
