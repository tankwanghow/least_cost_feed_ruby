require 'spec_helper'

describe Formula do
  let(:f) { create :formula }
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

end
