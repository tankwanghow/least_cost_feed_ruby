require 'spec_helper'

describe WelcomeController do

  context "GET index" do
    before(:each) do
      controller.should_not_receive :login_required
      get :index
    end
    it { expect(response).to render_template :index }
  end

end
