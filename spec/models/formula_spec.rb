require 'spec_helper'

describe Formula do
  let(:f) { create :formula }
  let(:fn1) { create :formula_nutrient, formula_id: f.id }
  let(:fn2) { create :formula_nutrient, formula_id: f.id }
  let(:fi1) { create :formula_ingredient, formula_id: f.id }
  let(:fi2) { create :formula_ingredient, formula_id: f.id }

  let(:user_1) { create :active_user }
  before(:each) { User.stub(:current).and_return user_1 }

  it { should have_db_column(:user_id).with_options(null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:batch_size).with_options(null: false, default: 0.0, precision: 12, scale: 4) }
  it { should have_db_column(:cost).with_options(null: false, default: 0.0, precision: 12, scale: 4) }
  it { should have_db_column(:lock_version).with_options(default: 0, null: false) }
  it { should have_db_column(:note) }
  it { should validate_numericality_of(:batch_size).is_greater_than_or_equal_to(0.0) } 
  it { should validate_numericality_of(:cost).is_greater_than_or_equal_to(0.0) } 

  it { should have_db_index([:user_id, :name]).unique(true) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :batch_size }
  it { should validate_presence_of :cost }
  it { f; should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should belong_to :user }
  it { should have_many(:formula_ingredients).dependent(:destroy) }
  it { should have_many(:formula_nutrients).dependent(:destroy) }

  it { should accept_nested_attributes_for :formula_nutrients }
  it { should accept_nested_attributes_for :formula_ingredients }

  it "should be timestamped" do
    should have_db_column :created_at
    should have_db_column :updated_at
  end

  context "self.find_formulas" do
    let(:user_2) { create :active_user }
    before(:each) do
      9.times { create :formula, user_id: user_1.id }
      7.times { create :formula, user_id: user_2.id }
    end
    it { expect(Formula.find_formulas('am', 1)).to eq user_1.formulas.where("name ilike '%am%'").page(1).per(25).order(:name) }
    it { expect(Formula.find_formulas).to eq user_1.formulas.page(1).per(25).order(:name) }
  end

  it 'self.create_like' do
    f.formula_nutrients << fn1
    f.formula_nutrients << fn2
    f.formula_ingredients << fi1
    f.formula_ingredients << fi2
    f.save
    a = Formula.create_like f.id
    expect(a.name).to       include f.name
    expect(a.user_id).to    eq f.user_id
    expect(a.cost).to       eq f.cost
    expect(a.batch_size).to eq f.batch_size
    expect(a.note).to       eq f.note
    f.formula_ingredients.each do |t|
      expect(a.formula_ingredients.find { |k| k.ingredient == t.ingredient }.max).to eq t.max
      expect(a.formula_ingredients.find { |k| k.ingredient == t.ingredient }.min).to eq t.min
      expect(a.formula_ingredients.find { |k| k.ingredient == t.ingredient }.actual).to eq t.actual
      expect(a.formula_ingredients.find { |k| k.ingredient == t.ingredient }.shadow).to eq t.shadow
      expect(a.formula_ingredients.find { |k| k.ingredient == t.ingredient }.use).to eq t.use
    end
    f.formula_nutrients.each do |t|
      expect(a.formula_nutrients.find { |k| k.nutrient == t.nutrient }.max).to eq t.max
      expect(a.formula_nutrients.find { |k| k.nutrient == t.nutrient }.min).to eq t.min
      expect(a.formula_nutrients.find { |k| k.nutrient == t.nutrient }.actual).to eq t.actual
      expect(a.formula_nutrients.find { |k| k.nutrient == t.nutrient }.use).to eq t.use
    end


    Formula.count.should == 2
  end

  it "calculate"
  it "savings"
  it "prev_cost"

end
