require 'spec_helper'

describe UsersController do
	let(:assign_user) { assigns :user }
  let(:admin_user) { create :admin_user }
  let(:any_user) { create :user }

  context "GET new" do
    before(:each) { get :new }
    it { should_not_receive :login_required }
    it { expect(assign_user.class).to be User }
    it { expect(assign_user).to be_new_record }
    it { expect(response).to render_template :new }
  end

  context "GET edit" do
    let(:edit_user) { create :user }
    before(:each) do
      login_as edit_user
      controller.should_receive(:login_required)
      get :edit, id: edit_user.id
    end
    it { expect(assign_user.class).to be User }
    it { expect(assign_user).not_to be_new_record }
    it { expect(assign_user.id).to be edit_user.id }
    it { expect(response).to render_template :edit }
  end

  context "POST create" do
    let(:assign_user) { assigns :user }
    let(:attrs_user) { attributes_for :user, status: 'active', is_admin: true }
    let(:attrs_invalid_user) { attributes_for :invalid_user }
    it { should_not_receive :login_required }
    context "any user" do
      before(:each) { controller.should_receive(:current_user).at_least(:once).and_return any_user }

      context "should protect from mass-assigment" do
        before(:each) { post :create, user: attrs_user }
        it { expect(assign_user.status).to eq 'pending' }
        it { expect(assign_user.is_admin).to be_false }
      end

      context "invalid user" do
        before(:each) { post :create, user: attrs_invalid_user }
        it { expect(assign_user.class).to be User }
        it { expect(assign_user).to be_new_record }
        it { expect(flash[:error]).to include "Ooppps" }
        it { expect(response).to render_template :new }
      end

      context 'valid user' do
        before(:each) { post :create, user: attrs_user }
        it { expect(assign_user.class).to be User }
        it { expect(assign_user).not_to be_new_record }
        it { expect(flash[:success]).to include "success" }
        it { expect(response).to redirect_to :login }
      end
    end

    context "admin user" do
      before(:each) do
        controller.should_receive(:current_user).at_least(:once).and_return admin_user
        post :create, user: attrs_user
      end
      context "should not protect from mass-assigment" do
        it { expect(assign_user.status).to eq 'active' }
        it { expect(assign_user.is_admin).to be_true }
      end
    end
  end
end