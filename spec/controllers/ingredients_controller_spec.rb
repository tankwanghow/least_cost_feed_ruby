require 'spec_helper'

describe IngredientsController do
  let(:assign_klass) { assigns :ingredient }

  it_should_be_authenticated_on :post, :create
  it_should_be_authenticated_on :get, :new
  it_should_be_authenticated_on :get, :edit, id: 3
  it_should_be_authenticated_on :delete, :destroy, id: 3

  it_should_authorize_access_own_data_on :get, :edit
  it_should_authorize_access_own_data_on :delete, :destroy
  it_should_authorize_access_own_data_on :patch, :update

  it_should_protect_mass_assigment_on_create :name, :cost, :status,:note, :batch_no
  it_should_protect_mass_assigment_on_update :name, :cost, :status,:note, :batch_no

  it_should_behave_like_destory
  it_should_behave_like_new
  it_should_behave_like_edit
  it_should_behave_like_create
  it_should_behave_like_update

  it "index"
end
