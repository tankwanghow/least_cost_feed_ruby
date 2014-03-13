require 'spec_helper'

describe User do
  let(:user) { create :user, name: 'bob' }

  it { should have_db_column(:username).with_options(null: false) }
  it { should have_db_column(:email) }
  it { should have_db_column(:password_digest).with_options(null: false) }
  it { should have_db_column(:name) }
  it { should have_db_column(:status).with_options(default: 'pending', null: false) }
  it { should have_db_column(:time_zone).with_options(default: 'Kuala Lumpur', null: false) }
  it { should have_db_column(:weight_unit).with_options(default: 'KG', null: false) }
  it { should have_db_column(:currency).with_options(default: 'MYR', null: false) }
  it { should have_db_column(:lock_version).with_options(default: 0, null: false) }
  it { should have_db_column(:is_admin).with_options(null: false, default: false) }

  it { should have_many(:ingredients) }

  it { should have_db_index(:username) }

  it "should be timestamped" do
    should have_db_column :created_at
    should have_db_column :updated_at
  end

  it { should validate_presence_of :username }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :currency }
  it { should validate_presence_of :time_zone }
  it { should validate_presence_of :weight_unit }
  it { should validate_presence_of :status }

  it { should validate_confirmation_of :password }    
  it { user; should validate_uniqueness_of :username }

  context "has_secure_password" do
    it { expect(user.respond_to?(:password_digest)).to be_true }
    it { expect(user.respond_to?(:authenticate)).to be_true }
    it { expect(user.password).not_to be(user.password_digest) }
  end

  context "SentientUser" do
    it { expect(User.respond_to?(:current)).to be_true }
  end

  context "self.find_users" do
    before(:each) do
      10.times { create :active_user }
      10.times { create :user }
    end
    it { expect(User.find_users('al')).to eq User.where("username || name || email || status ilike '%al%'").page(1).per(25).order(:name) }
    it { expect(User.find_users).to eq User.all.page(1).per(25).order(:name) }
  end

end
