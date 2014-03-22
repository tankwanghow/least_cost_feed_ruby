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
end