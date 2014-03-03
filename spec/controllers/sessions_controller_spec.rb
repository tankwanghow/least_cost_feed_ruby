require 'spec_helper'

describe SessionsController do
  let(:user) { create :active_user }
  before(:each) do request.env['HTTP_REFERER'] = 'http://test.host/mama/bapa'
  end

  context "POST create" do
    context "logged in" do
      before(:each) do
        controller.should_receive(:current_user).at_least(:once).and_return user
        post :create
      end
      it { should_not_receive :login_required }
      it { expect(response).to redirect_to :back }
      it { expect(flash["notice"]).to include "logged in" }
    end

    context "not log in" do
      before(:each) { controller.should_receive(:current_user).at_least(:once).and_return nil }

      context "valid username, invalid password" do
        before(:each) do
          User.should_receive(:find_by_username).with(user.username).and_return user
          user.should_receive(:authenticate).with('secret').and_return false
          post :create, session: { username: user.username, password: 'secret' }
        end
        it { should_not_receive :login_required }
        it { expect(response).to redirect_to :login }
        it { expect(flash[:error]).to include "Invalid" }
      end

      context "valid user" do 
        before(:each) do
          User.should_receive(:find_by_username).with(user.username).and_return user
          user.should_receive(:authenticate).with('secret').and_return true
          post :create, session: { username: user.username, password: 'secret' }
        end
        it { should_not_receive :login_required }
        it { expect(session[:user_id]).to eq user.id }
        it { expect(response).to redirect_to :dashboard }
        it { expect(flash[:success]).to include "success" }
      end

      context "pending user" do
        before(:each) do
          User.should_receive(:find_by_username).with(user.username).and_return user
          user.should_receive(:authenticate).with('secret').and_return true
          user.should_receive(:status).and_return 'pending'
          post :create, session: { username: user.username, password: 'secret' }
        end
        it { should_not_receive :login_required }
        it { expect(response).to redirect_to :root }
        it { expect(flash[:notice]).to include "pending" }
      end

      context "invalid username" do 
        before(:each) do
          User.should_receive(:find_by_username).with(user.username).and_return nil
          post :create, session: { username: user.username }
        end
        it { should_not_receive :login_required }
        it { expect(response).to redirect_to :login }
        it { expect(flash[:error]).to include "Invalid" }
      end
    end
  end
  
  context "GET new" do
    context "logged in" do
      before(:each) do
        controller.should_receive(:current_user).at_least(:once).and_return user
        get :new
      end
      it { should_not_receive :login_required }
      it { expect(response).to redirect_to :back }
      it { expect(flash["notice"]).to include "logged in" }
    end

    context "not log in" do
      before(:each) do
        controller.should_receive(:current_user).at_least(:once).and_return nil
        get :new
      end
      it { should_not_receive :login_required }
      it { expect(response).to render_template :new }
    end
  end

  context "DELETE destroy" do
    context "logged in" do
      before(:each) do
        controller.should_receive(:current_user).at_least(:once).and_return user
        controller.session[:user_id] = user.id
        delete :destroy
      end
      it { should_not_receive :login_required }
      it { expect(response).to redirect_to :root }
      it { expect(flash["notice"]).to include 'Logged Out' }
      it { expect(session[:user_id]).to be_nil }
    end
  end

end
