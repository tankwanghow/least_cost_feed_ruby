require 'spec_helper'

describe UsersController do
	let(:assign_user) { assigns :user }
  let(:admin_user) { create :admin_user }
  let(:any_user) { create :user, name: 'mama' }
  before(:each) { request.env['HTTP_REFERER'] = 'http://test.host/HTTP_REFERER' }

  context "PATCH update" do
    let(:edit_user) { create :user, name: 'haha' }
    
    it "should authenticate" do
      patch :update, id: edit_user.id
      expect(response).to redirect_to :login
    end

    context "Permitted to update user, login normal user" do
      before(:each) do
        login_as edit_user
        controller.should_receive(:fetch_user).and_return edit_user
      end
      context "update success" do
        before(:each) do
          edit_user.should_receive(:update_attributes).with(edit_user.attributes.select { |k,v| ["username", "email", "name", "password", "password_confirmation"].include? k }).and_return true
          patch :update, id: edit_user.id, user: edit_user.attributes
        end
        it { expect(assign_user).to eq edit_user }
        it { expect(flash[:success]).to include "success", "updated" }
        it { expect(response).to redirect_to :root }
      end
      context "update failure" do
        before(:each) do
          edit_user.should_receive(:update_attributes).and_return false
          patch :update, id: edit_user.id, user: edit_user.attributes
        end
        it { expect(assign_user).to eq edit_user }
        it { expect(flash[:danger]).to include "Failed" }
        it { expect(response).to render_template :edit }
      end
    end

    context "Permitted to update user, login admin user" do
      before(:each) do
        login_as admin_user
        controller.should_receive(:fetch_user).and_return edit_user
      end
      context "update success" do
        before(:each) do
          edit_user.should_receive(:update_attributes).with(edit_user.attributes.select { |k,v| ["username", "email", "name", "password", "password_confirmation", "is_admin", "status"].include? k }).and_return true
          patch :update, id: edit_user.id, user: edit_user.attributes
        end
        it { expect(assign_user).to eq edit_user }
        it { expect(flash[:success]).to include "success", "updated" }
        it { expect(response).to redirect_to :root }
      end
      context "update failure" do
        before(:each) do
          edit_user.should_receive(:update_attributes).and_return false
          patch :update, id: edit_user.id, user: edit_user.attributes
        end
        it { expect(assign_user).to eq edit_user }
        it { expect(flash[:danger]).to include "Failed" }
        it { expect(response).to render_template :edit }
      end
    end
  end

  context "GET new" do
    before(:each) { get :new }
    it { should_not_receive :login_required }
    it { expect(assign_user.class).to be User }
    it { expect(assign_user).to be_new_record }
    it { expect(response).to render_template :new }
  end

  context "GET edit" do
    let(:edit_user) { create :user, name: 'haha' }

    it "should authenticate" do
      get :edit, id: edit_user.id
      expect(response).to redirect_to :login
    end

    context "Logged in as normal user" do
      before(:each) { login_as edit_user }
      context "editing current_user" do
        before(:each) { get :edit, id: edit_user.id }
        it { expect(assign_user).to eq edit_user }
        it { expect(response).to render_template :edit }
      end
      context "editing different user" do
        before(:each) { get :edit, id: any_user.id }
        it { expect(assign_user).not_to eq any_user }
        it { expect(response).to redirect_to :back }
        it { expect(flash[:danger]).to include "Cannot edit other user." }
      end
    end

    context "Logged in as admin" do
      before(:each) { login_as admin_user }
      context "editing current_user" do
        before(:each) { get :edit, id: admin_user.id }
        it { expect(assign_user).to eq admin_user }
        it { expect(response).to render_template :edit }
      end
      context "editing different user" do
        before(:each) { get :edit, id: any_user.id }
        it { expect(assign_user).to eq any_user }
        it { expect(response).to render_template :edit }
      end
    end

  end

  context "POST create" do
    let(:assign_user) { assigns :user }
    let(:attrs_user) { attributes_for :user, status: 'active', is_admin: true }
    let(:attrs_invalid_user) { attributes_for :invalid_user }
    
    it "should not authenticate" do
      controller.should_not_receive(:login_required)
      post :create, user: attrs_user
    end

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
        it { expect(flash[:danger]).to include "Ooppps" }
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