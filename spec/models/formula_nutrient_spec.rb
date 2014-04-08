require 'spec_helper'

describe FormulaNutrient do

  let(:f) { create :formula_nutrient }
  let(:user_1) { create :active_user }
  before(:each) { User.stub(:current).and_return user_1 }

  it { should have_db_column(:formula_id).with_options(null: false) }
  it { should have_db_column(:nutrient_id).with_options(null: false) }
  it { should have_db_column(:max).with_options(precision: 12, scale: 6) }
  it { should have_db_column(:min).with_options(precision: 12, scale: 6) }
  it { should have_db_column(:actual).with_options(null: false, default: 0.0, precision: 12, scale: 6) }
  it { should have_db_column(:use).with_options(null: false, default: true) }

  it { should validate_numericality_of(:actual).is_greater_than_or_equal_to(0.0) }

  it { should have_db_index([:nutrient_id, :formula_id]).unique(true) }

  it { should validate_presence_of :nutrient_id }
  it { f; should validate_uniqueness_of(:nutrient_id).scoped_to(:formula_id) }
  it { should belong_to :formula }
  it { should belong_to :nutrient }

  it { expect(f.nutrient_name_unit).to eq "#{f.nutrient.name}(#{f.nutrient.unit})" }

  it "nutrient_name_unit should return nil" do
    f.nutrient = nil
    f.nutrient_name_unit.should == nil
  end

end

