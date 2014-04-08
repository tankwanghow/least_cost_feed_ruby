require 'spec_helper'

describe FormulaIngredient do

  let(:f) { create :formula_ingredient }
  let(:user_1) { create :active_user }
  before(:each) { User.stub(:current).and_return user_1 }

  it { should have_db_column(:formula_id).with_options(null: false) }
  it { should have_db_column(:ingredient_id).with_options(null: false) }
  it { should have_db_column(:max).with_options(precision: 12, scale: 6) }
  it { should have_db_column(:min).with_options(precision: 12, scale: 6) }
  it { should have_db_column(:actual).with_options(null: false, default: 0.0, precision: 12, scale: 6) }
  it { should have_db_column(:shadow).with_options(null: false, default: 0.0, precision: 12, scale: 6) }
  it { should have_db_column(:use).with_options(null: false, default: true) }

  it { should validate_numericality_of(:actual).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:shadow).is_greater_than_or_equal_to(0.0) }

  it { should have_db_index([:ingredient_id, :formula_id]).unique(true) }

  it { should validate_presence_of :ingredient_id }
  it { f; should validate_uniqueness_of(:ingredient_id).scoped_to(:formula_id) }
  it { should belong_to :formula }
  it { should belong_to :ingredient }

  it { expect(f.ingredient_name).to eq "#{f.ingredient.name}" }
  it { expect(f.ingredient_cost).to eq f.ingredient.cost }

  it "should update ingredient cost" do
    f.ingredient_cost = 999
    expect(f.ingredient.cost).to eq 999
  end

  it "should save ingredient if it changed the ingredient" do
    f.ingredient_cost = 998
    f.max = 100
    f.save
    expect(Ingredient.find(f.ingredient_id).cost).to eq 998
  end

  it "ingredient_name should return nil" do
    f.ingredient = nil
    f.ingredient.should == nil
  end

  it "min_perc should return min * 100, min not nil" do
    expect(f.min_perc).to eq f.min * 100
  end

  it "min_perc should return nil, min is nil" do
    f.min = nil
    expect(f.min_perc).to be_nil
  end

  it "min_perc= should set min to value/100, if value not blank" do
    f.min_perc = 30
    expect(f.min).to eq 0.3
  end

  it "min_perc= should set min to nil, if value not blank" do
    f.min_perc = ""
    expect(f.min).to be_nil
  end

  it "max_perc should return max * 100, max not nil" do
    expect(f.max_perc).to eq f.max * 100
  end

  it "max_perc should return nil, max is nil" do
    f.max = nil
    expect(f.max_perc).to be_nil
  end

  it "max_perc= should set max to value/100, if value not blank" do
    f.max_perc = 30
    expect(f.max).to eq 0.3
  end

  it "max_perc= should set max to nil, if value not blank" do
    f.max_perc = ""
    expect(f.max).to be_nil
  end

  it "actual_perc should return actual * 100, actual not nil" do
    expect(f.actual_perc).to eq f.actual * 100
  end

  it "actual_perc should return nil, actual is nil" do
    f.actual = nil
    expect(f.actual_perc).to be_nil
  end

  it "actual_perc= should set actual to value/100, if value not blank" do
    f.actual_perc = 30
    expect(f.actual).to eq 0.3
  end

  it "actual_perc= should set actual to nil, if value not blank" do
    f.actual_perc = ""
    expect(f.actual).to be_nil
  end
  
end
