require 'spec_helper'

describe IngredientComposition do
  let(:ic) { create :ingredient_composition }

  it { should have_db_column :value }
  it { should have_db_column :ingredient_id }
  it { should have_db_column :nutrient_id }
  it { should belong_to :ingredient }
  it { should belong_to :nutrient }
  it { should have_db_index([:ingredient_id, :nutrient_id]).unique(true) }
  it { should validate_presence_of :value }
  it { should validate_presence_of :nutrient_id }
  it { should validate_numericality_of(:value).is_greater_than_or_equal_to(0.0) }
  it { ic; should validate_uniqueness_of(:nutrient_id).scoped_to(:ingredient_id) }

  it { expect(ic.nutrient_name_unit).to eq "#{ic.nutrient.name}(#{ic.nutrient.unit})" }
  
  it "nutrient_name_unit should return nil" do
    ic.nutrient = nil
    ic.nutrient_name_unit.should == nil
  end
  
  it "should touch ingredient after_update" do
    ic.value = 9.0
    expect(ic.ingredient).to receive(:touch)
    ic.save
  end
end
