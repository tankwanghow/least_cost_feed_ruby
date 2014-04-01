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


  it { should validate_numericality_of(:max).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:min).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:actual).is_greater_than_or_equal_to(0.0) }
  it { should validate_numericality_of(:shadow).is_greater_than_or_equal_to(0.0) }

  it { should have_db_index([:ingredient_id, :formula_id]).unique(true) }

  it { should validate_presence_of :ingredient_id }
  it { f; should validate_uniqueness_of(:ingredient_id).scoped_to(:formula_id) }
  it { should belong_to :formula }
  it { should belong_to :ingredient }

  it { expect(f.ingredient_name).to eq "#{f.ingredient.name}" }

  it { expect(f.ingredient_cost).to eq f.ingredient.cost }

  it "ingredient_name should return nil" do
    f.ingredient = nil
    f.ingredient.should == nil
  end
  
end
