require 'spec_helper'

describe Nutrient do
  let(:n) { create :nutrient }

  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:unit).with_options(null: false) }
  it { should have_db_column(:user_id).with_options(null: false) }
  it { should have_db_column(:lock_version).with_options(default: 0, null: false) }
  it { should have_db_index([:user_id, :name]).unique(true) }

  it "should be timestamped" do
    should have_db_column :created_at
    should have_db_column :updated_at
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :unit }
  it { should validate_presence_of :user }
  it { n; should validate_uniqueness_of :name }

  it { should belong_to :user }

  context "self.find_nutrients" do
    let(:user_1) { create :active_user }
    let(:user_2) { create :active_user }
    before(:each) do
      9.times { create :nutrient, user_id: user_1.id }
      7.times { create :nutrient, user_id: user_2.id }
      expect(User).to receive(:current).and_return user_1
    end
    it { expect(Nutrient.find_nutrients('al', 1)).to eq user_1.nutrients.where("name || unit || note ilike '%al%'").page(1).per(25).order(:name) }
    it { expect(Nutrient.find_nutrients).to eq user_1.nutrients.page(1).per(25).order(:name) }
  end
end