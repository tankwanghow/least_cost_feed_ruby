require 'spec_helper'

describe Ingredient do
  let(:i) { create :ingredient }

  it { should have_db_column(:user_id).with_options(null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:cost).with_options(null: false, default: 0.0, precision: 12, scale: 4) }
  it { should have_db_column(:lock_version).with_options(default: 0, null: false) }

  it { should have_db_column(:batch_no) }
  it { should have_db_column(:note) }
  it { should have_db_column(:status).with_options(default: 'pending', null: false) }

  it { should have_db_index([:user_id, :name, :batch_no]).unique(true) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :cost }
  it { should validate_presence_of :status }

  it "should be timestamped" do
    should have_db_column :created_at
    should have_db_column :updated_at
  end

  it { i; should validate_uniqueness_of(:name).scoped_to(:user_id, :batch_no) }
  it { should belong_to :user }

  context "self.find_ingredients" do
    let(:user_1) { create :active_user }
    let(:user_2) { create :active_user }
    before(:each) do
      9.times { create :ingredient, user_id: user_1.id }
      7.times { create :ingredient, user_id: user_2.id }
      expect(User).to receive(:current).and_return user_1
    end
    it { expect(Ingredient.find_ingredients('al', 1)).to eq user_1.ingredients.where("name || batch_no || status || note ilike '%al%'").page(1).per(25).order(:name, :batch_no) }
    it { expect(Ingredient.find_ingredients).to eq user_1.ingredients.page(1).per(25).order(:name, :batch_no) }
  end
end
