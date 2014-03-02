class DietGlpsol
  def self.solution_for_formula formula, filename, solver=Rails.root.to_s + '/lib/bin/glpsol --math'
    filename = Rails.root.to_s + "/tmp/" + filename
    gmpl_for_formula formula, filename
    solution_for_gmpl filename, solver
  end

  def self.solution_for_gmpl filename, solver
    a = `#{solver + " " + filename}`
    `rm #{filename}`
    formula = a.scan(/FORMULA_START(.+?)FORMULA_END/)
    specs = a.scan(/SPECS_START(.+?)SPECS_END/)
    if formula.empty? or specs.empty?
      nil
    else
      { formula: formula.flatten[0].split('|').compact, specs: specs.flatten[0].split('|').compact }
    end
  end

  def self.gmpl_for_formula formula, filename
    f = File.new filename, 'w'
    f.puts varibles formula.ingredients
    f.puts objective_function formula.ingredients
    f.puts nutrient_expressions_constraints formula.nutrients, formula.ingredients
    f.puts constraint_100 formula.ingredients
    f.puts ingredients_constraints formula.ingredients
    f.puts 'solve;'
    f.puts "printf 'FORMULA_START';\n"
    f.puts printf_statement_for_ingredients formula.ingredients
    f.puts "printf 'FORMULA_END';\n"
    f.puts "printf 'SPECS_START';\n"
    f.puts printf_statement_for_nutrients formula.nutrients.map { |n| n.nutrient }
    f.puts "printf 'SPECS_END';\n"
    f.puts 'end;'
    f.close
  end

  def self.constraint_100 ingredients
    "PERC: " + ingredients.map { |i| "+p_#{i.id}"}.join(" ") + " = 1;\n"
  end

  def self.varible ingredient
    "var p_#{ingredient.id} >= 0;"
  end

  def self.varibles ingredients
    ingredients.map { |i| varible(i) }.join("\n") + "\n"
  end

  def self.ingredient_expression ingredient
    "+#{ingredient.cost}*p_#{ingredient.id}"
  end

  def self.objective_function ingredients
    "minimize cost: " + ingredients.map { |i| ingredient_expression(i) }.join(" ") + ";\n"
  end

  def self.ingredient_constraint ingredient
    constraint = constraint(ingredient, "p_#{ingredient.id}")
    constraint ? "s.t.pc_#{ingredient.id}: " + constraint(ingredient, "p_#{ingredient.id}") : nil
  end

  def self.ingredients_constraints ingredients
    ingredients.map { |i| ingredient_constraint(i) }.compact.join("\n") + "\n"
  end

  def self.nutrient_expression nutrient, ingredient
    innu= ingredient.nutrients.find { |t| t.nutrient.id == nutrient.id }
    innu.value > 0 ? "+#{innu.value}*p_#{ingredient.id}" : nil
  end

  def self.nutrient_expressions nutrient, ingredients
    ingredients.map { |i| nutrient_expression(nutrient, i) }.compact.join(" ")
  end

  def self.nutrient_expressions_constraint nutrient_spec, ingredients
    exp = constraint(nutrient_spec, nutrient_expressions(nutrient_spec.nutrient, ingredients))
    if exp != " >= 0;"
      "n_#{nutrient_spec.nutrient.id}: " + constraint(nutrient_spec, nutrient_expressions(nutrient_spec.nutrient, ingredients))
    else
      "n_#{nutrient_spec.nutrient.id}: " + ingredients.map { |i| "+p_#{i.id}"}.join(" ") + " >= 0;"
    end
  end

  def self.nutrient_expressions_constraints nutrient_specs, ingredients
    nutrient_specs.map { |n| nutrient_expressions_constraint(n, ingredients) }.compact.join("\n") + "\n"
  end

  def self.printf_statement_for_ingredient ingredient
    "printf 'p_#{ingredient.id},%.6f,%.6f|', p_#{ingredient.id}.val, p_#{ingredient.id}.dual;"
  end

  def self.printf_statement_for_ingredients ingredients
    ingredients.map { |i| printf_statement_for_ingredient(i) }.join("\n") + "\n"
  end

  def self.printf_statement_for_nutrient nutrient
    "printf 'n_#{nutrient.id},%.6f|', n_#{nutrient.id}.val;"
  end

  def self.printf_statement_for_nutrients nutrients
    nutrients.map { |n| printf_statement_for_nutrient(n) }.join("\n") + "\n"
  end

private

  def self.constraint object, expression=""
    if object.max && object.min
      gt_lt_constraint(object, expression)
    elsif object.max && !object.min
      lt_constraint(object, expression)
    elsif object.min && !object.max
      gt_constraint(object, expression)
    else
      gt_zero_constraint(object, expression)
    end
  end

  def self.gt_lt_constraint object, expression
    "#{object.min} <= #{expression} <= #{object.max};"
  end

  def self.gt_constraint object, expression
    "#{expression} >= #{object.min};"
  end

  def self.lt_constraint object, expression
    "#{expression} <= #{object.max};"
  end

  def self.gt_zero_constraint object, expression
    "#{expression} >= 0;"
  end
end
