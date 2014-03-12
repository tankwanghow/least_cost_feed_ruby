require 'spec_helper'

describe IngredientsController do
  let(:assign_ingredient) { assigns :ingredient }

  let(:any_user) { create :user }
  let(:ingredient) { build(:ingredient) }
  let(:ingredient_attrs) { ingredient.attributes }
  let(:invalid_ingredient_attrs) { build(:invalid_ingredient).attributes }

  context "GET index" do
    it "should authenticate" do
      get :index
      expect(response).to redirect_to :login
    end

    context "Authenticated" do
      let(:assign_terms) { assigns :terms }
      before(:each) do
        login_as any_user
      end
      it "should render index" do
        Ingredient.should_receive(:find_ingredients)
        get :index
        expect(response).to render_template :index
      end
      it "should set assign_terms with params[:search][:terms]" do
        Ingredient.should_receive(:find_ingredients).with('xxxx')
        get :index, search: { terms: 'xxxx' }
        expect(assign_terms).to eq 'xxxx'
      end
      it "assign_terms should be nil" do
        Ingredient.should_receive(:find_ingredients)
        get :index
        expect(assign_terms).to be_nil
      end
    end

  end

  context "Authenticated" do
    before(:each) { login_as any_user }
    it "should protect mass-assigment, on PATCH update" do
      edit_ingredient = create(:ingredient, user_id: any_user.id)
      controller.should_receive(:fetch_ingredient).and_return edit_ingredient
      expect(edit_ingredient).to receive(:update_attributes).with(permitted_params( ingredient_attrs, [:name, :cost, :status,:note, :batch_no]))
      patch :update, id: edit_ingredient.id, ingredient: ingredient_attrs
      expect(assign_ingredient).to eq edit_ingredient
    end

    it "should protect mass-assigment, on POST create" do
      new_ingredient = build(:ingredient, user_id: any_user.id)
      Ingredient.should_receive(:new).with(permitted_params(new_ingredient.attributes, [:name, :cost, :status, :note, :batch_no])).and_return new_ingredient
      post :create, ingredient: new_ingredient.attributes
      expect(assign_ingredient).to eq new_ingredient
    end
  end

  context "DELETE destroy" do
    let(:ingredient) { create :ingredient, user_id: any_user.id }
    it "should authenticate" do
      delete :destroy, id: 2
      expect(response).to redirect_to :login
    end
    context "Authenticated" do
      before(:each) do
        login_as any_user
        expect(controller).to receive(:fetch_ingredient).and_return ingredient
        delete :destroy, id: ingredient.id
      end
      it { expect(ingredient.destroyed?).to be_true }
      it { expect(flash[:success]).to include 'destroyed' }
      it { expect(response).to redirect_to ingredients_path }
    end
  end

  context "PATCH update" do
    it "should authenticate" do
      patch :update, id: 2
      expect(response).to redirect_to :login
    end

    context "Authenticated" do
      let(:edit_ingredient) { create(:ingredient, user_id: any_user.id) }
      let(:valid_ingredient_attrs) { { "name" => 'haha', "cost" => "456.6" } }
      let(:invalid_ingredient_attrs) { { "name" => 'hah', "cost" => nil } }
      before(:each) do
        login_as any_user
        expect(controller).to receive(:fetch_ingredient).and_return edit_ingredient
      end
      
      context "invalid Record" do
        before(:each) do
          expect(edit_ingredient).to receive(:update_attributes).with(invalid_ingredient_attrs).and_return false
          patch :update, id: edit_ingredient.id, ingredient: invalid_ingredient_attrs
        end
        it { expect(assign_ingredient).to be edit_ingredient }
        it { expect(flash[:danger]).to include "Ooppps" }
        it { expect(response).to render_template :edit }
      end

      context "Valid Record" do
        before(:each) do
          expect(edit_ingredient).to receive(:update_attributes).with(valid_ingredient_attrs).and_return true
          patch :update, id: edit_ingredient.id, ingredient: valid_ingredient_attrs
        end
        it { expect(assign_ingredient).to be edit_ingredient }
        it { expect(flash[:success]).to include "success" }
        it { expect(response).to render_template :edit }
      end
    end
  end

  context "GET edit" do
    let(:other_user) { create :user }
    it "should authenticate" do
      get :edit, id: 2
      expect(response).to redirect_to :login
    end

    context "Authenticated" do
      before(:each) { login_as any_user }
      
      context "editing own Ingredient" do
        let(:edit_ingredient) { create(:ingredient, user_id: any_user.id) }
        let(:dbl) { double }
        before(:each) do
          expect(controller.current_user).to receive(:ingredients).and_return dbl
          expect(dbl).to receive(:find).with(edit_ingredient.id.to_s).and_return edit_ingredient
          get :edit, id: edit_ingredient.id
        end
        it { expect(assign_ingredient).to be edit_ingredient }
        it { expect(response).to render_template :edit }
      end

      context "Editing other user ingredient" do
        let(:other_user) { create :user }
        let(:edit_ingredient) { create(:ingredient, user_id: other_user.id) }
        let(:dbl) { double }
        before(:each) do
          expect(controller.current_user).to receive(:ingredients).and_return dbl
          expect(dbl).to receive(:find).with(edit_ingredient.id.to_s).and_raise(ActiveRecord::RecordNotFound)
          get :edit, id: edit_ingredient.id
        end
        it { expect(flash[:danger]).to include "Record Not Found" }
        it { expect(response).to redirect_to :root }
      end
    end

  end

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

  context "POST create" do
    it "should authenticate" do
      post :create
      expect(response).to redirect_to :login
    end

    context "Authenticated" do
      before(:each) do
        login_as any_user
        expect(Ingredient).to receive(:new).and_return ingredient
        post :create, ingredient: ingredient_attrs
      end
      it { expect(assign_ingredient.class).to be Ingredient }
      it { expect(assign_ingredient.user_id).to eq any_user.id }
    end

    context "valid record" do
      before(:each) do
        login_as any_user
        post :create, ingredient: ingredient_attrs
      end
      it { expect(flash[:success]).to include "success" }
      it { expect(response).to render_template :index }
    end

    context "invalid record" do
      before(:each) do
        login_as any_user
        post :create, ingredient: { name: nil, cost: nil   }
      end
      it { expect(flash[:danger]).to include "Ooppps" }
      it { expect(response).to render_template :new }
    end
  end
end
