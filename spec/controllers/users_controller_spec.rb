require 'spec_helper'

describe UsersController do
	let(:assign_user) { assigns :user }
  let(:admin_user) { create :admin_user }
  let(:any_user) { create :user, username: 'mama' }
  before(:each) { request.env['HTTP_REFERER'] = 'http://test.host/HTTP_REFERER' }

  it_should_not_be_authenticated_on :get, :new
  it_should_not_be_authenticated_on :post, :create
  it_should_be_authenticated_on :get, :edit, id: 1
  it_should_be_authenticated_on :patch, :update, id: 2
  it_should_be_authenticated_on :get, :index

  context "permitted_params" do
    context "any user, editing self" do
      it "should allow all params but :is_admin and :status" do
        login_as any_user
        User.stub(:find).and_return any_user
        any_user.should_receive(:update).with(permitted_params(any_user.attributes, [:username, :email, :name, :password, :password_confirmation, :country, :time_zone, :weight_unit]))
        patch :update, id: any_user.id, user: any_user.attributes
      end
    end

    context "admin user, editing other user" do
      it "should allow :password, :password_confirmation, :is_admin, :status" do
        login_as admin_user
        User.stub(:find).with(admin_user.id).and_return admin_user
        User.stub(:find).with(any_user.id).and_return any_user
        any_user.should_receive(:update).with(permitted_params(any_user.attributes, [:password, :password_confirmation, :is_admin, :status]))
        patch :update, id: any_user.id, user: any_user.attributes
      end
    end
    
    context "admin user, editing self" do
      it "should allow all params" do
        login_as admin_user
        User.stub(:find).and_return admin_user
        admin_user.should_receive(:update).with(permitted_params(admin_user.attributes, [:username, :email, :name, :password, :password_confirmation, :country, :time_zone, :weight_unit, :is_admin, :status]))
        patch :update, id: admin_user.id, user: admin_user.attributes
      end
    end
  end    

  context "GET index" do
    context "Authenticated" do
      context "Not Admin" do
        before(:each) do
          login_as any_user
          get :index
        end
        it { expect(response).to redirect_to :root }
        it { expect(flash[:danger]).to include 'Unauthorize' }
      end
    end

    context "Authenticated" do
      let(:assign_users) { assigns :users }
      let(:dbl) { double }
      before(:each) { login_as admin_user }
      context "Is Admin and has terms" do
        before(:each) do
          expect(User).to receive(:find_users).with('xxx').and_return dbl
          expect(dbl).to receive(:page).with '10'
          get :index, search: { terms: 'xxx' }, page: 10
        end
        it { expect(response).to render_template :index }
      end
      context "Is Admin and has no terms" do
        before(:each) do
          expect(User).to receive(:find_users).with(nil).and_return dbl
          expect(dbl).to receive(:page).with '10'
          get :index, page: 10
        end
        it { expect(response).to render_template :index }
      end
    end

  end

  context "PATCH update" do
    context "Permitted to update self when login as normal user" do
      before(:each) do
        login_as any_user
        User.stub(:find).and_return any_user
      end
      context "update success" do
        before(:each) do
          any_user.should_receive(:update).and_return true
          patch :update, id: any_user.id, user: any_user.attributes
        end
        it { expect(assign_user).to eq any_user }
        it { expect(flash[:success]).to include "success", "updated" }
        it { expect(response).to redirect_to :root }
      end

      context "update failure" do
        before(:each) do
          any_user.should_receive(:update).and_return false
          patch :update, id: any_user.id, user: any_user.attributes
        end
        it { expect(assign_user).to eq any_user }
        it { expect(flash[:danger]).to include "Failed" }
        it { expect(response).to render_template :edit }
      end
    end

    context "Permitted to update other user when login as admin user" do
      before(:each) do
        login_as admin_user
        User.stub(:find).with(admin_user.id).and_return admin_user
        User.stub(:find).with(any_user.id).and_return any_user
      end
      context "update success" do
        before(:each) do
          any_user.should_receive(:update).and_return true
          patch :update, id: any_user.id, user: any_user.attributes
        end
        it { expect(assign_user).to eq any_user }
        it { expect(flash[:success]).to include "success", "updated" }
        it { expect(response).to redirect_to :root }
      end
      context "update failure" do
        before(:each) do
          any_user.should_receive(:update).and_return false
          patch :update, id: any_user.id, user: any_user.attributes
        end
        it { expect(assign_user).to eq any_user }
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
    context "any user, User.count gt 200" do
      before(:each) { expect(User).to receive(:count).and_return 201 }

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
        it { expect(flash[:success]).to include "Pending" }
        it { expect(response).to redirect_to :login }
      end
    end

    context "any user, User.count lt 200" do
      before(:each) { expect(User).to receive(:count).and_return 10 }

      context "should protect from mass-assigment" do
        before(:each) { post :create, user: attrs_user }
        it { expect(assign_user.status).to eq 'active' }
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
        it { expect(flash[:success]).to include "Please Login" }
        it { expect(response).to redirect_to :login }
      end
    end
  end
end