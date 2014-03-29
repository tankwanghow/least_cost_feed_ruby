require 'csv'

CSV.foreach(File.expand_path('./db/nutrients.csv'), headers: true, col_sep: ',') do |d|
  Nutrient.create! name: d["Nutrient"], unit: d['Unit'], category: 'sample', user_id: User.first.id
end

CSV.foreach(File.expand_path('./db/ingredients.csv'), headers: true, col_sep: ',') do |d|
  Ingredient.create! name: d["Name"], cost: d['Price'], category: 'sample', user_id: User.first.id
end

CSV.foreach(File.expand_path('./db/ingredient_compositions.csv'), headers: true, col_sep: ',') do |d|
  i = Ingredient.find_by_name(d['Ingredient'])
  d.each do |t|
    n = Nutrient.find_by_name(t[0]) if t[0] != "Ingredient"
    IngredientComposition.create! nutrient_id: n.id, ingredient_id: i.id, value: t[1] if t[1] && n && i
  end
end
