require_relative '../../lib/diet_glpsol'

describe DietGlpsol do
  let(:me)      { double(id: 1, name: 'ME',      unit: 'kcal/kg') }
  let(:protein) { double(id: 2, name: 'Protein', unit: '%')       }
  let(:calcium) { double(id: 3, name: 'Calcium', unit: '%')       }
  let(:nothing) { double(id: 4, name: 'Nothing', unit: 'n')       }

  let(:nutrients) { [me, protein, calcium, nothing] }

  let(:corn_compositions)      { [ double(nutrient: me, value: 3350), double(nutrient: protein, value:  8.3), double(nutrient: calcium, value: 0.02), double(nutrient: nothing, value: 1) ] }
  let(:soyabean_compositions)  { [ double(nutrient: me, value: 2450), double(nutrient: protein, value: 47.5), double(nutrient: calcium, value: 0.30), double(nutrient: nothing, value: 2) ] }
  let(:wheatbran_compositions) { [ double(nutrient: me, value: 1300), double(nutrient: protein, value: 15.0), double(nutrient: calcium, value: 0.10), double(nutrient: nothing, value: 4) ] }
  let(:limestone_compositions) { [ double(nutrient: me, value:    0), double(nutrient: protein, value:    0), double(nutrient: calcium, value: 38.0), double(nutrient: nothing, value: 5) ] }
  let(:mdcp_compositions)      { [ double(nutrient: me, value:    0), double(nutrient: protein, value:    0), double(nutrient: calcium, value: 18.0), double(nutrient: nothing, value: 9) ] }

  let(:corn)      { double(id: 1, name: 'Corn',          cost: 0.9500, ingredient_compositions: corn_compositions)      }
  let(:soyabean)  { double(id: 2, name: 'Soyabean Meal', cost: 1.8000, ingredient_compositions: soyabean_compositions)  }
  let(:wheatbran) { double(id: 3, name: 'Wheat Bran',    cost: 0.7900, ingredient_compositions: wheatbran_compositions) }
  let(:limestone) { double(id: 4, name: 'Limestone',     cost: 0.0650, ingredient_compositions: limestone_compositions) }
  let(:mdcp)      { double(id: 5, name: 'MDCP',          cost: 1.7500, ingredient_compositions: mdcp_compositions)      }

  let(:ingredients) { [corn, soyabean, wheatbran, limestone, mdcp] }

  let(:formula1_nutrients) { [ double(nutrient: me, max: nil, min: 2800), double(nutrient: protein, max: 16, min:  nil), double(nutrient: calcium, max: 4.1, min: 3.8), double(nutrient: nothing, max: nil, min: nil) ] }
  let(:formula2_nutrients) { [ double(nutrient: me, max: nil, min: 8000), double(nutrient: protein, max: 50, min:  nil), double(nutrient: calcium, max: 4.1, min: 3.8), double(nutrient: nothing, max: nil, min: nil) ] }

  let(:formula1_ingredients) { [ 
    double(ingredient: corn,      max: 0.70, min: 0.40), 
    double(ingredient: soyabean,  max:  nil, min: 0.15), 
    double(ingredient: wheatbran, max: 0.50, min:  nil),
    double(ingredient: limestone, max:  nil, min:  nil),
    double(ingredient: mdcp,      max:  nil, min:  nil)
  ] }

  let(:formula2_ingredients) { [ 
    double(ingredient: corn,      max: 0.70, min: 0.60), 
    double(ingredient: soyabean,  max:  nil, min: 0.20), 
    double(ingredient: wheatbran, max: 0.30, min:  nil),
    double(ingredient: limestone, max:  nil, min:  nil),
    double(ingredient: mdcp,      max:  nil, min:  nil)
  ] }

  let(:formula1)  { double(id: 1, name: 'Layer', formula_ingredients: formula1_ingredients, formula_nutrients: formula1_nutrients) }
  let(:formula2)  { double(id: 2, name: 'Swine', formula_ingredients: formula2_ingredients, formula_nutrients: formula2_nutrients) }

  it "should find the solution for formula" do
    filename = "abc#{rand(5000)}xyz.mod"
    DietGlpsol.solution_for_formula(formula1, filename).should == {
      formula: ["p_1,0.700000,0.000000", "p_2,0.167552,0.000000", "p_3,0.034230,0.000000", "p_4,0.098219,0.000000", "p_5,0.000000,1.903611"],
      specs:   ["n_1,2800.000000", "n_2,14.282146", "n_3,3.800000", "n_4,1.663116"]
    }
  end

  it "should delete the solved file" do
    filename = "abc#{rand(5000)}xyz.mod"
    DietGlpsol.solution_for_formula(formula1, filename)
    Proc.new { File.open(filename) }.should raise_error
  end

  it "should return nil, if solution not found" do
    filename = "abc#{rand(5000)}xyz.mod"
    DietGlpsol.solution_for_formula(formula2, filename).should == nil
  end

  it "should be return the solution, if soultion found" do
    filename = "abc#{rand(5000)}xyz.mod"
    DietGlpsol.solution_for_formula(formula1, filename).should == {
      formula: ["p_1,0.700000,0.000000", "p_2,0.167552,0.000000", "p_3,0.034230,0.000000", "p_4,0.098219,0.000000", "p_5,0.000000,1.903611"],
      specs:   ["n_1,2800.000000", "n_2,14.282146", "n_3,3.800000", "n_4,1.663116"] }
  end

  it "should generate full gmpl file" do
    filename = "abc#{rand(5000)}xyz.mod"
    DietGlpsol.gmpl_for_formula(formula1, filename)
    Proc.new { File.open(filename) }.should_not raise_error
    `rm #{filename}`
  end

  it "should generate printf for nutrients" do
    DietGlpsol.printf_statement_for_nutrients([me, protein, calcium, nothing]).should ==
    "printf 'n_1,%.6f|', n_1.val;\n" +
    "printf 'n_2,%.6f|', n_2.val;\n" +
    "printf 'n_3,%.6f|', n_3.val;\n" +
    "printf 'n_4,%.6f|', n_4.val;\n"
  end

  it "should generate printf for nutrient" do
    DietGlpsol.printf_statement_for_nutrient(me).should == "printf 'n_1,%.6f|', n_1.val;"
  end

  it "should generate printf for ingredients" do
    DietGlpsol.printf_statement_for_ingredients(formula1_ingredients).should == 
    "printf 'p_1,%.6f,%.6f|', p_1.val, p_1.dual;\n" +
    "printf 'p_2,%.6f,%.6f|', p_2.val, p_2.dual;\n" +
    "printf 'p_3,%.6f,%.6f|', p_3.val, p_3.dual;\n" +
    "printf 'p_4,%.6f,%.6f|', p_4.val, p_4.dual;\n" +
    "printf 'p_5,%.6f,%.6f|', p_5.val, p_5.dual;\n"
  end

  it "should generate printf for ingredient" do
    DietGlpsol.printf_statement_for_ingredient(corn).should == "printf 'p_1,%.6f,%.6f|', p_1.val, p_1.dual;"
  end

  it "should generate nutrients expressions constraints" do
    DietGlpsol.nutrient_expressions_constraints(formula1_nutrients, formula1_ingredients).should == 
    "n_1: +3350*p_1 +2450*p_2 +1300*p_3 >= 2800;\n" +
    "n_2: +8.3*p_1 +47.5*p_2 +15.0*p_3 <= 16;\n" +
    "n_3: 3.8 <= +0.02*p_1 +0.3*p_2 +0.1*p_3 +38.0*p_4 +18.0*p_5 <= 4.1;\n" +
    "n_4: +1*p_1 +2*p_2 +4*p_3 +5*p_4 +9*p_5 >= 0;\n"
  end

  it "should generate gt zero constraint" do
    DietGlpsol.nutrient_expressions(formula1_nutrients[3].nutrient, formula1_ingredients).should == "+1*p_1 +2*p_2 +4*p_3 +5*p_4 +9*p_5"
  end

  it "should generate nutrient l.t. expressions constraint" do
    DietGlpsol.nutrient_expressions_constraint(formula1_nutrients[1], formula1_ingredients).should == "n_2: +8.3*p_1 +47.5*p_2 +15.0*p_3 <= 16;"
  end

  it "should generate nutrient g.t. expressions constraint" do
    DietGlpsol.nutrient_expressions_constraint(formula1_nutrients[0], formula1_ingredients).should == "n_1: +3350*p_1 +2450*p_2 +1300*p_3 >= 2800;"
  end

  it "should generate nutrient g.t. and l.t. expressions constraint" do
    DietGlpsol.nutrient_expressions_constraint(formula1_nutrients[2], formula1_ingredients).should == "n_3: 3.8 <= +0.02*p_1 +0.3*p_2 +0.1*p_3 +38.0*p_4 +18.0*p_5 <= 4.1;"
  end

  it "should generate nutrient expressions" do
    DietGlpsol.nutrient_expressions(protein, formula1_ingredients).should == "+8.3*p_1 +47.5*p_2 +15.0*p_3"
  end

  it "should not generate nutrient expression" do
    DietGlpsol.nutrient_expression(protein, limestone).should == nil
  end

  it "should generate nutrient expression" do
    DietGlpsol.nutrient_expression(calcium, corn).should == "+0.02*p_1"
  end

  it "should generate 100% default constraint" do
    DietGlpsol.constraint_100(formula1_ingredients).should == "PERC: +p_1 +p_2 +p_3 +p_4 +p_5 = 1;\n"
  end

  it "should generate ingredients constraints" do
    DietGlpsol.ingredients_constraints(formula1_ingredients).should ==
    "s.t.pc_1: 0.4 <= p_1 <= 0.7;\n" +
    "s.t.pc_2: p_2 >= 0.15;\n" +
    "s.t.pc_3: p_3 <= 0.5;\n" +
    "s.t.pc_4: p_4 >= 0;\n" +
    "s.t.pc_5: p_5 >= 0;\n"
  end

  it "should generate zero constraint" do
    DietGlpsol.ingredient_constraint(formula1_ingredients[3]).should == "s.t.pc_4: p_4 >= 0;"
  end

  it "should generate l.t. ingredient constraint" do
    DietGlpsol.ingredient_constraint(formula1_ingredients[2]).should == "s.t.pc_3: p_3 <= 0.5;"
  end

  it "should generate g.t. ingredient constraint" do
    DietGlpsol.ingredient_constraint(formula1_ingredients[1]).should == "s.t.pc_2: p_2 >= 0.15;"
  end

  it "should generate g.t. and l.t. ingredient constraint" do
    DietGlpsol.ingredient_constraint(formula1_ingredients[0]).should == "s.t.pc_1: 0.4 <= p_1 <= 0.7;"
  end

  it "should generate minimize objective function" do
    DietGlpsol.objective_function(formula1_ingredients).should == "minimize cost: +0.95*p_1 +1.8*p_2 +0.79*p_3 +0.065*p_4 +1.75*p_5;\n"
  end

  it "should generate ingredient cost expression" do
    DietGlpsol.ingredient_expression(wheatbran).should == "+0.79*p_3"
  end

  it "should generate varible string for given ingredient" do
    DietGlpsol.varible(mdcp).should == "var p_5 >= 0;"
  end

  it "should generate_varibles string for given ingredients" do
    DietGlpsol.varibles(formula1_ingredients).should == "var p_1 >= 0;\nvar p_2 >= 0;\nvar p_3 >= 0;\nvar p_4 >= 0;\nvar p_5 >= 0;\n"
  end
end