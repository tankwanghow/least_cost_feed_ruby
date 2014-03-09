require 'spec_helper'

describe IngredientsController do
  let(:assign_ingredient) { assigns :ingredient }
  let(:any_user) { create :user }

  context "GET new" do
    it "should authenticate" do
      get :new
      expect(response).to redirect_to :login
    end

    context "Authenticated" do
      before(:each) do
        login_as any_user
        get :new
      end
      it { expect(assign_ingredient.class).to be Ingredient }
      it { expect(assign_ingredient).to be_new_record }
      it { expect(response).to render_template :new }
    end
  end
end
