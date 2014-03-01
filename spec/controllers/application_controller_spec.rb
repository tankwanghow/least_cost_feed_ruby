require 'spec_helper'

class TestBeforeFilterInApplicationController < ApplicationController
  def haha
    render nothing: true
  end
end

describe TestBeforeFilterInApplicationController do
  before(:each) do
    add_dynamic_get_route 'haha' => 'test_before_filter_in_application#haha'
    get :haha
  end
  it { expect(response).to redirect_to :login }
end

describe ApplicationController do

  context "Authentication" do
    it { should respond_to :login_required }
    it { should respond_to :current_user }
    it { should respond_to :logged_in? }
    it { should respond_to :redirect_to_target_or_default }
  end

end