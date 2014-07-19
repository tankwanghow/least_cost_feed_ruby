require_relative '../../lib/diet_glpsol'

N  = Struct.new(:id, :name, :unit)
I  = Struct.new(:id, :name, :cost, :ingredient_compositions)
IC = Struct.new(:nutrient, :value)
F  = Struct.new(:id, :name, :formula_ingredients, :formula_nutrients)
FI = Struct.new(:ingredient, :max, :min, :_destroy, :use)
FN = Struct.new(:nutrient, :max, :min, :_destroy, :use)

describe DietGlpsol do
  let(:n1)   { N.new(1) }
  let(:ic1) { IC.new(n1, 0.02) }
  let(:ic2) { IC.new(n1,  0.3) }
  let(:ic3) { IC.new(n1,  0.1) }
  let(:ic4) { IC.new(n1, 38.0) }
  let(:ic5) { IC.new(n1, 18.0) }

  # it "should only use formula_ingredients of _destroy false and use true" do
  #   filename = "abc#{rand(5000)}xyz.mod"
  #   expect(DietGlpsol).to receive(:varibles).with([
  #     formula3_ingredients[0], 
  #     formula3_ingredients[1], 
  #     formula3_ingredients[2], 
  #     formula3_ingredients[3],
  #     formula3_ingredients[4]
  #   ])
  #   DietGlpsol.gmpl_for_formula formula3, filename
  # end

  # it "should only use formula_nutrients of _destroy false" do
  #   filename = "abc#{rand(5000)}xyz.mod"
  #   expect(DietGlpsol).to receive(:nutrient_expressions_constraints).with(
  #     [
  #       formula3_nutrients[0],
  #       formula3_nutrients[1],
  #       formula3_nutrients[2],
  #       formula3_nutrients[3],
  #       formula3_nutrients[5],
  #       formula3_nutrients[6],
  #     ],
  #     [
  #       formula3_ingredients[0], 
  #       formula3_ingredients[1], 
  #       formula3_ingredients[2], 
  #       formula3_ingredients[3],
  #       formula3_ingredients[4]
  #     ])
  #   DietGlpsol.gmpl_for_formula formula3, filename
  # end

  # it 'unuse nutrient only calculate actual, use constraint >= 0'

  # it "should find the solution for formula" do
  #   filename = "abc#{rand(5000)}xyz.mod"
  #   DietGlpsol.solution_for_formula(formula1, filename).should == {
  #     formula: ["p_1,0.700000,0.000000", "p_2,0.167552,0.000000", "p_3,0.034230,0.000000", "p_4,0.098219,0.000000", "p_5,0.000000,1.903611"],
  #     specs:   ["n_1,2800.000000", "n_2,14.282146", "n_3,3.800000", "n_4,1.663116"]
  #   }
  # end

  # it "should delete the solved file" do
  #   filename = "abc#{rand(5000)}xyz.mod"
  #   DietGlpsol.solution_for_formula(formula1, filename)
  #   Proc.new { File.open(filename) }.should raise_error
  # end

  # it "should return nil, if solution not found" do
  #   filename = "abc#{rand(5000)}xyz.mod"
  #   DietGlpsol.gmpl_for_formula formula2, filename
  #   DietGlpsol.solution_for_gmpl(filename).should == nil
  # end

  # it "should be return the solution, if soultion found" do
  #   filename = "abc#{rand(5000)}xyz.mod"
  #   DietGlpsol.gmpl_for_formula formula1, filename
  #   DietGlpsol.solution_for_gmpl(filename).should == {
  #     formula: ["p_1,0.700000,0.000000", "p_2,0.167552,0.000000", "p_3,0.034230,0.000000", "p_4,0.098219,0.000000", "p_5,0.000000,1.903611"],
  #     specs:   ["n_1,2800.000000", "n_2,14.282146", "n_3,3.800000", "n_4,1.663116"] }
  # end

  # it "should generate full gmpl file" do
  #   filename = "abc#{rand(5000)}xyz.mod"
  #   DietGlpsol.gmpl_for_formula(formula1, filename)
  #   Proc.new { File.open(filename) }.should_not raise_error
  #   `rm #{filename}`
  # end

  # it "should generate printf for nutrients" do
  #   DietGlpsol.printf_statement_for_nutrients([me, protein, calcium, nothing]).should ==
  #   "printf 'n_1,%.6f|', n_1.val;\n" +
  #   "printf 'n_2,%.6f|', n_2.val;\n" +
  #   "printf 'n_3,%.6f|', n_3.val;\n" +
  #   "printf 'n_4,%.6f|', n_4.val;\n"
  # end

  # it "should generate printf for nutrient" do
  #   DietGlpsol.printf_statement_for_nutrient(me).should == "printf 'n_1,%.6f|', n_1.val;"
  # end

  # it "should generate printf for ingredients" do
  #   DietGlpsol.printf_statement_for_ingredients(formula1_ingredients).should == 
  #   "printf 'p_1,%.6f,%.6f|', p_1.val, p_1.dual;\n" +
  #   "printf 'p_2,%.6f,%.6f|', p_2.val, p_2.dual;\n" +
  #   "printf 'p_3,%.6f,%.6f|', p_3.val, p_3.dual;\n" +
  #   "printf 'p_4,%.6f,%.6f|', p_4.val, p_4.dual;\n" +
  #   "printf 'p_5,%.6f,%.6f|', p_5.val, p_5.dual;\n"
  # end

  # it "should generate printf for ingredient" do
  #   DietGlpsol.printf_statement_for_ingredient(corn).should == "printf 'p_1,%.6f,%.6f|', p_1.val, p_1.dual;"
  # end

  # it "should generate nutrients expressions constraints" do
  #   DietGlpsol.nutrient_expressions_constraints(formula1_nutrients, formula1_ingredients).should == 
  #   "n_1: +3350*p_1 +2450*p_2 +1300*p_3 >= 2800;\n" +
  #   "n_2: +8.3*p_1 +47.5*p_2 +15.0*p_3 <= 16;\n" +
  #   "n_3: 3.8 <= +0.02*p_1 +0.3*p_2 +0.1*p_3 +38.0*p_4 +18.0*p_5 <= 4.1;\n" +
  #   "n_4: +1*p_1 +2*p_2 +4*p_3 +5*p_4 +9*p_5 >= 0;\n"
  # end

  it "should generate gt zero constraint" do
    i1  = I.new(1, 't1', 123, [ic1])
    i2  = I.new(2, 't2', 456, [ic2])
    i3  = I.new(3, 't2', 789, [ic3])
    i4  = I.new(4, 't4',  12, [ic4])
    i5  = I.new(5, 't5',  46, [ic5])
    formula_ingredients = [FI.new(i1), FI.new(i2), FI.new(i3), FI.new(i4), FI.new(i5)]
    formula_nutrient = FN.new(n, nil, nil, false, true)
    DietGlpsol.nutrient_expressions_constraint(formula_nutrient, formula_ingredients).should == "n_3: +0.02*p_1 +0.3*p_2 +0.1*p_3 +38.0*p_4 +18.0*p_5 >= 0;"
  end

  it "should generate nutrient l.t. expressions constraint" do
    i1  = I.new(1, 't1', 123, [ic1])
    i2  = I.new(2, 't2', 456, [ic2])
    i3  = I.new(3, 't2', 789, [ic3])
    i4  = I.new(4, 't4',  12, [ic4])
    i5  = I.new(5, 't5',  46, [ic5])
    formula_ingredients = [FI.new(i1), FI.new(i2), FI.new(i3), FI.new(i4), FI.new(i5)]
    formula_nutrient = FN.new(n, 4.1, nil, false, true)
    DietGlpsol.nutrient_expressions_constraint(formula_nutrient, formula_ingredients).should == "n_3: +0.02*p_1 +0.3*p_2 +0.1*p_3 +38.0*p_4 +18.0*p_5 <= 4.1;"
  end

  it "should generate nutrient g.t. expressions constraint" do
    i1  = I.new(1, 't1', 123, [ic1])
    i2  = I.new(2, 't2', 456, [ic2])
    i3  = I.new(3, 't2', 789, [ic3])
    i4  = I.new(4, 't4',  12, [ic4])
    i5  = I.new(5, 't5',  46, [ic5])
    formula_ingredients = [FI.new(i1), FI.new(i2), FI.new(i3), FI.new(i4), FI.new(i5)]
    formula_nutrient = FN.new(n, nil, 3.8, false, true)
    DietGlpsol.nutrient_expressions_constraint(formula_nutrient, formula_ingredients).should == "n_3: +0.02*p_1 +0.3*p_2 +0.1*p_3 +38.0*p_4 +18.0*p_5 >= 3.8;"
  end

  it "should generate nutrient g.t. and l.t. expressions constraint" do
    i1  = I.new(1, 't1', 123, [ic1])
    i2  = I.new(2, 't2', 456, [ic2])
    i3  = I.new(3, 't2', 789, [ic3])
    i4  = I.new(4, 't4',  12, [ic4])
    i5  = I.new(5, 't5',  46, [ic5])
    formula_ingredients = [FI.new(i1), FI.new(i2), FI.new(i3), FI.new(i4), FI.new(i5)]
    formula_nutrient = FN.new(n, 4.1, 3.8, false, true)
    DietGlpsol.nutrient_expressions_constraint(formula_nutrient, formula_ingredients).should == "n_3: 3.8 <= +0.02*p_1 +0.3*p_2 +0.1*p_3 +38.0*p_4 +18.0*p_5 <= 4.1;"
  end

  it "should generate nutrient expressions" do
    n   = N.new(1)
    ic1 = IC.new(n,  8.3)
    ic2 = IC.new(n, 47.5)
    ic3 = IC.new(n, 15.0)
    i1  = I.new(1, 't1', 123, [ic1])
    i2  = I.new(2, 't2', 456, [ic2])
    i3  = I.new(3, 't2', 789, [ic3])
    formula_ingredients = [FI.new(i1), FI.new(i2), FI.new(i3)]
    DietGlpsol.nutrient_expressions(n, formula_ingredients).should == "+8.3*p_1 +47.5*p_2 +15.0*p_3"
  end

  it "should not generate nutrient expression" do
    n = N.new(1)
    n1 = N.new(2)
    i = I.new(1)
    i.ingredient_compositions = [IC.new(n, 0.02)]
    DietGlpsol.nutrient_expression(n1, i).should == nil
  end

  it "should generate nutrient expression" do
    n = N.new(1)
    i = I.new(1)
    i.ingredient_compositions = [IC.new(n, 0.02)]
    DietGlpsol.nutrient_expression(n, i).should == "+0.02*p_1"
  end

  it "should generate 100% default constraint" do
    formula_ingredients = [FI.new(I.new(1)), FI.new(I.new(2)), FI.new(I.new(3)), FI.new(I.new(4)), FI.new(I.new(5))]
    DietGlpsol.constraint_100(formula_ingredients).should == "PERC: +p_1 +p_2 +p_3 +p_4 +p_5 = 1;\n"
  end

  it "should generate ingredients constraints" do
    formula_ingredients = [
      FI.new(I.new(1), 0.7,  0.4),
      FI.new(I.new(2), nil, 0.15),
      FI.new(I.new(3), 0.5,  nil),
      FI.new(I.new(4), nil,  nil),
      FI.new(I.new(5), nil,  nil)
    ]
    DietGlpsol.ingredients_constraints(formula_ingredients).should ==
    "s.t.pc_1: 0.4 <= p_1 <= 0.7;\n" +
    "s.t.pc_2: p_2 >= 0.15;\n" +
    "s.t.pc_3: p_3 <= 0.5;\n" +
    "s.t.pc_4: p_4 >= 0;\n" +
    "s.t.pc_5: p_5 >= 0;\n"
  end

  it "should generate zero constraint" do
    formula_ingredient = FI.new(I.new(4), nil, nil)
    DietGlpsol.ingredient_constraint(formula_ingredient).should == "s.t.pc_4: p_4 >= 0;"
  end

  it "should generate l.t. ingredient constraint" do
    formula_ingredient = FI.new(I.new(3), 0.5, nil)
    DietGlpsol.ingredient_constraint(formula_ingredient).should == "s.t.pc_3: p_3 <= 0.5;"
  end

  it "should generate g.t. ingredient constraint" do
    formula_ingredient = FI.new(I.new(2), nil, 0.15)
    DietGlpsol.ingredient_constraint(formula_ingredient).should == "s.t.pc_2: p_2 >= 0.15;"
  end

  it "should generate g.t. and l.t. ingredient constraint" do
    formula_ingredient = FI.new(I.new(1), 0.7, 0.4)
    DietGlpsol.ingredient_constraint(formula_ingredient).should == "s.t.pc_1: 0.4 <= p_1 <= 0.7;"
  end

  it "should generate minimize objective function" do
    formula_ingredients = [
      FI.new(I.new(1, 'bran1',  0.95)), 
      FI.new(I.new(2, 'bran2',   1.8)), 
      FI.new(I.new(3, 'bran3',  0.79)), 
      FI.new(I.new(4, 'bran4', 0.065)), 
      FI.new(I.new(5, 'bran5',  1.75))
    ]
    DietGlpsol.objective_function(formula_ingredients).should == "minimize cost: +0.95*p_1 +1.8*p_2 +0.79*p_3 +0.065*p_4 +1.75*p_5;\n"
  end

  it "should generate ingredient cost expression" do
    DietGlpsol.ingredient_expression(I.new(3, 'bran', 0.79)).should == "+0.79*p_3"
  end

  it "should generate varible string for given ingredient" do
    DietGlpsol.varible(I.new(5)).should == "var p_5 >= 0;"
  end

  it "should generate_varibles string for given ingredients" do
    formula_ingredients = [
      FI.new(I.new(1)), FI.new(I.new(2)), FI.new(I.new(3)), FI.new(I.new(4)), FI.new(I.new(5))
    ]
    DietGlpsol.varibles(formula_ingredients).should == "var p_1 >= 0;\nvar p_2 >= 0;\nvar p_3 >= 0;\nvar p_4 >= 0;\nvar p_5 >= 0;\n"
  end
end