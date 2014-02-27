require 'spec_helper'

describe User do
  let(:user) { create :user, name: 'bob' }

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

  context "searchable" do
    it { expect(user.respond_to?(:searchable_options)).to be_true }
    it { expect(user.searchable_options[:content]).to eq([:name, :username, :email, :status]) }
  end

end
