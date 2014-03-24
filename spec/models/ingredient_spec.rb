require 'spec_helper'

describe Ingredient do
  let(:i) { create :ingredient }
  let(:user_1) { create :active_user }
  before(:each) { User.stub(:current).and_return user_1 }

  it { should have_db_column(:user_id).with_options(null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:cost).with_options(null: false, default: 0.0, precision: 12, scale: 4) }
  it { should have_db_column(:lock_version).with_options(default: 0, null: false) }

  it { should have_db_column(:batch_no) }
  it { should have_db_column(:note) }
  it { should have_db_column(:status).with_options(default: 'using', null: false) }
  it { should have_db_column(:category).with_options(default: 'private', null: false) }
  it { should validate_numericality_of(:cost).is_greater_than_or_equal_to(0.0) } 

  it { should have_db_index([:user_id, :name, :batch_no]).unique(true) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :cost }
  it { should validate_presence_of :status }
  it { should validate_presence_of :category }
  it { should have_many(:ingredient_compositions).dependent(:destroy) }

  it "should be timestamped" do
    should have_db_column :created_at
    should have_db_column :updated_at
  end

  it { i; should validate_uniqueness_of(:name).scoped_to(:user_id, :batch_no) }
  it { should belong_to :user }
  it { should accept_nested_attributes_for :ingredient_compositions }

  it "new should added default nutrients" do
    9.times { create :nutrient, user_id: user_1.id }
    expect(Ingredient.new_with_ingredient_compositions.ingredient_compositions.size).to eq 9
  end

  context "self.find_ingredients" do
    let(:user_2) { create :active_user }
    before(:each) do
      9.times { create :ingredient, user_id: user_1.id }
      7.times { create :ingredient, user_id: user_2.id }
    end
    it { expect(Ingredient.find_ingredients('sam', 1)).to eq user_1.ingredients.where("name || batch_no || status || category ilike '%sam%'").page(1).per(25).order(:name, :batch_no) }
    it { expect(Ingredient.find_ingredients).to eq user_1.ingredients.page(1).per(25).order(:name, :batch_no) }
  end
end
