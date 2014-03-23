require 'spec_helper'

describe NutrientsController do

  let(:assign_klass) { assigns :nutrient }

  it_should_be_authenticated_on :post, :create
  it_should_be_authenticated_on :get, :new
  it_should_be_authenticated_on :get, :edit, id: 3
  it_should_be_authenticated_on :delete, :destroy, id: 3

  it_should_authorize_access_own_data_on :get, :edit
  it_should_authorize_access_own_data_on :delete, :destroy
  it_should_authorize_access_own_data_on :patch, :update

  it_should_protect_mass_assigment_on_create :name, :unit, :note

  it_should_protect_mass_assigment_on_update :name, :unit, :note

  it_should_behave_like_destory
  it_should_behave_like_new
  it_should_behave_like_edit
  it_should_behave_like_create
  it_should_behave_like_update

  it "index"
end
