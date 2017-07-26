require 'csv'

class User < ActiveRecord::Base
  has_secure_password
  include SentientUser
  validates :username, uniqueness: true
  validates :name, :username, :time_zone, :country, :weight_unit, :status, :email, presence: true
  has_many :ingredients, dependent: :destroy
  has_many :nutrients, dependent: :destroy
  has_many :formulas, dependent: :destroy
  has_many :premixes

  after_create :add_sample_nutrients_and_ingredients

  def self.find_users terms=nil, page=1
    if terms.blank?
      User.all.page(page).order(:name)
    else
      User.where("username || name || email || status ilike ?", "%#{terms}%").page(page).order(:name)
    end
  end

  def logged_in
    self.last_login_at = DateTime.now
    self.save
  end

private

  def add_sample_nutrients_and_ingredients
    if changes["status"] && changes["status"][1] == 'active' && Rails.env != 'test'
      seed_sample_nutrients
      seed_sample_ingredients
      seed_sample_ingredient_nutrients
      seed_sample_formula
    end
  end

  def seed_sample_formula
    f = Formula.create! name: 'Sample', batch_size: 1000, user_id: self.id
    fi = [[true, "Limestone",            0.092912,  185.824,  0       ],
          [true, "Wheat Bran",           0.082865,  165.73,   0       ],
          [true, "Palm Oil",             0.075485,  150.97,   0       ],
          [true, "MDCP21",               0.011939,  23.878,   0       ],
          [true, "DL-Methionine 99",     0.002162,  4.324,    0       ],
          [true, "Sodium Bicab",         0.000919,  1.838,    0       ],
          [true, "L-Threonine",          0,         0,        9.924164],
          [true, "Rice Bran",            0,         0,        0.152984],
          [true, "SS Soyabean Meal DHP",  0.369659,  739.318,  0       ],
          [true, "Common Salt",          0.00284,   5.68,     0       ],
          [true, "L-Lysine HCl",         0,         0,        8.254647]]

    fn = [[true, "Calcium",               3.9,  4.1, 3.9      ],
          [true, "Chlorine",              0.17, 0.2, 0.2      ],
          [true, "Choline",               1.4,  nil, 1.4      ],
          [true, "Crude Fiber",           3,    5.5, 3        ],
          [true, "Crude Protein",         18,   nil, 21.199256],
          [true, "Isoleucine",            0.7,  nil, 0.873824 ],
          [true, "Linoleic Acid",         1.8,  nil, 1.920556 ],
          [true, "Lysine",                0.91, nil, 1.140147 ],
          [true, "Met + Cys",             0.8,  nil, 0.8      ],
          [true, "Metab. Energy", 2.85, nil, 2.85     ],
          [true, "Methionine",            0.46, nil, 0.50734  ],
          [true, "Sodium",                0.17, nil, 0.17     ],
          [true, "Threonine",             0.66, nil, 0.736926 ],
          [true, "Tryptophan",            0.21, nil, 0.265001 ],
          [true, "Valine",                0.78, nil, 0.954362 ]]

    fi.each do |t|
      i = Ingredient.find_by_name_and_user_id t[1], self.id
      FormulaIngredient.create! formula_id: f.id, ingredient_id: i.id, actual: t[2], weight: t[3], shadow: t[4], use: t[0]
    end

    fn.each do |t|
      n = Nutrient.find_by_name_and_user_id(t[1], self.id)
      FormulaNutrient.create! formula_id: f.id, nutrient_id: n.id, actual: t[4], use: t[0], min: t[2], max: t[3]
    end
  end

  def seed_sample_ingredients
    CSV.foreach(File.expand_path("app/models/sample_data/ingredients.csv"), headers: true, col_sep: ',') do |d|
      Ingredient.create! name: d["Name"], cost: d['Price'], category: 'sample', user_id: self.id
    end
  end

  def seed_sample_nutrients
    CSV.foreach(File.expand_path("app/models/sample_data/nutrients.csv"), headers: true, col_sep: ',') do |d|
      Nutrient.create! name: d["Nutrient"], unit: d['Unit'], category: 'sample', user_id: self.id
    end
  end

  def seed_sample_ingredient_nutrients
    CSV.foreach(File.expand_path("app/models/sample_data/ingredient_compositions.csv"), headers: true, col_sep: ',') do |d|
      i = Ingredient.find_by_name_and_user_id(d['Ingredient'], self.id)
      d.each do |t|
        n = Nutrient.find_by_name_and_user_id(t[0], self.id) if t[0] != "Ingredient"
        IngredientComposition.create! nutrient_id: n.id, ingredient_id: i.id, value: t[1] if t[1] && n && i
      end
    end
  end

end
