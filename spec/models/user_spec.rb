require 'spec_helper'

describe User do
  let(:user) { create :user, name: 'bob' }

  it { should have_db_column(:username).with_options(null: false) }
  it { should have_db_column(:email) }
  it { should have_db_column(:password_digest).with_options(null: false) }
  it { should have_db_column(:name) }
  it { should have_db_column(:status).with_options(default: 'pending', null: false) }
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

end
