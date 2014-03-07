require 'spec_helper'

describe Ingredient do
  let(:i) { create :ingredient }

  it { should have_db_column(:user_id).with_options(null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:cost).with_options(null: false, default: 0.0, precision: 12, scale: 4) }
  it { should have_db_column(:lock_version).with_options(default: 0, null: false) }
  it { should have_db_index([:user_id, :name]).unique(true) }

  it "should be timestamped" do
    should have_db_column :created_at
    should have_db_column :updated_at
  end

  it { i; should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should belong_to :user }

end
