class DietGlpsol
  def self.solution_for_formula formula, filename, solver=Rails.root.to_s + '/lib/bin/glpsol --math'
    filename = Rails.root.to_s + "/tmp/" + filename
    gmpl_for_formula formula, filename
    solution_for_gmpl filename, solver
  end

  def self.solution_for_gmpl filename, solver=Rails.root.to_s + '/lib/bin/glpsol --math'
    a = `#{solver + " " + filename}`
    formula = a.scan(/FORMULA_START(.+?)FORMULA_END/)
    specs = a.scan(/SPECS_START(.+?)SPECS_END/)
    if formula.empty? or specs.empty?
      nil
    else
      `rm #{filename}`
      { formula: formula.flatten[0].split('|').compact, specs: specs.flatten[0].split('|').compact }
    end
  end

  def self.gmpl_for_formula formula, filename
    f = File.new filename, 'w'
    formula_ingredients = formula.formula_ingredients.select { |t| t._destroy == false && t.use }
    formula_nutrients   = formula.formula_nutrients.select { |t| t._destroy == false }
    f.puts varibles formula_ingredients
    f.puts objective_function formula_ingredients
    f.puts nutrient_expressions_constraints formula_nutrients, formula_ingredients
    f.puts constraint_100 formula_ingredients
    f.puts ingredients_constraints formula_ingredients
    f.puts 'solve;'
    f.puts "printf 'FORMULA_START';\n"
    f.puts printf_statement_for_ingredients formula_ingredients
    f.puts "printf 'FORMULA_END';\n"
    f.puts "printf 'SPECS_START';\n"
    f.puts printf_statement_for_nutrients formula_nutrients.map { |n| n.nutrient }
    f.puts "printf 'SPECS_END';\n"
    f.puts 'end;'
    f.close
  end

  def self.constraint_100 formula_ingredients
    "PERC: " + formula_ingredients.map { |i| "+p_#{i.ingredient.id}"}.join(" ") + " = 1;\n"
  end

  def self.varible ingredient
    "var p_#{ingredient.id} >= 0;"
  end

  def self.varibles formula_ingredients
    formula_ingredients.map { |i| varible(i.ingredient) }.join("\n") + "\n"
  end

  def self.ingredient_expression ingredient
    "+#{ingredient.cost}*p_#{ingredient.id}"
  end

  def self.objective_function formula_ingredients
    "minimize cost: " + formula_ingredients.map { |i| ingredient_expression(i.ingredient) }.join(" ") + ";\n"
  end

  def self.ingredient_constraint formula_ingredient
    constraint = constraint(formula_ingredient, "p_#{formula_ingredient.ingredient.id}")
    constraint ? "s.t.pc_#{formula_ingredient.ingredient.id}: " + constraint(formula_ingredient, "p_#{formula_ingredient.ingredient.id}") : nil
  end

  def self.ingredients_constraints formula_ingredients
    formula_ingredients.map { |i| ingredient_constraint(i) }.compact.join("\n") + "\n"
  end

  def self.nutrient_expression nutrient, ingredient
    innu = ingredient.ingredient_compositions.find { |t| t.nutrient.id == nutrient.id }
    if innu
      innu.value > 0 ? "+#{innu.value}*p_#{ingredient.id}" : nil
    else
      nil
    end
  end

  def self.nutrient_expressions nutrient, formula_ingredients
    formula_ingredients.map { |i| nutrient_expression(nutrient, i.ingredient) }.compact.join(" ")
  end

  def self.nutrient_expressions_constraint nutrient_spec, formula_ingredients
    exp = constraint(nutrient_spec, nutrient_expressions(nutrient_spec.nutrient, formula_ingredients))
    if nutrient_spec.use
      "n_#{nutrient_spec.nutrient.id}: " + constraint(nutrient_spec, nutrient_expressions(nutrient_spec.nutrient, formula_ingredients))
    else
      "n_#{nutrient_spec.nutrient.id}: " + gt_zero_constraint(nutrient_spec, nutrient_expressions(nutrient_spec.nutrient, formula_ingredients))
    end
  end

  def self.nutrient_expressions_constraints nutrient_specs, ingredients
    nutrient_specs.map { |n| nutrient_expressions_constraint(n, ingredients) }.compact.join("\n") + "\n"
  end

  def self.printf_statement_for_ingredient ingredient
    "printf 'p_#{ingredient.id},%.6f,%.6f|', p_#{ingredient.id}.val, p_#{ingredient.id}.dual;"
  end

  def self.printf_statement_for_ingredients ingredients
    ingredients.map { |i| printf_statement_for_ingredient(i.ingredient) }.join("\n") + "\n"
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
