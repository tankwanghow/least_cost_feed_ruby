require 'spec_helper'

describe IngredientsController do
  let(:assign_klass) { assigns :ingredient } # used by controller macros
  let(:klass_attributes) {
    { 
      name:     "mama", 
      cost:     "32", 
      batch_no: "", 
      status:   "using", 
      note:     "", 
      ingredient_compositions_attributes:
          [{nutrient_id: "10", value: "2", _destroy: false, id: "1"}, 
           {nutrient_id: "3",  value: "3", _destroy: false, id: "1"}, 
           {nutrient_id: "2",  value: "4", _destroy: false, id: "1"}, 
           {nutrient_id: "9",  value: "5", _destroy: false, id: "1"}, 
           {nutrient_id: "6",  value: "4", _destroy: false, id: "1"}, 
           {nutrient_id: "1",  value: "3", _destroy: false, id: "1"}, 
           {nutrient_id: "4",  value: "3", _destroy: false, id: "1"}, 
           {nutrient_id: "8",  value: "4", _destroy: false, id: "1"}, 
           {nutrient_id: "5",  value: "4", _destroy: false, id: "1"}, 
           {nutrient_id: "7",  value: "5", _destroy: false, id: "1"}]
    }
  }

  it_should_be_authenticated_on :get,    :index
  it_should_be_authenticated_on :post,   :create
  it_should_be_authenticated_on :get,    :new
  it_should_be_authenticated_on :get,    :edit,    id: 3
  it_should_be_authenticated_on :patch,  :update,  id: 3
  it_should_be_authenticated_on :delete, :destroy, id: 3

  it_should_authorize_access_own_data_on :get,    :edit
  it_should_authorize_access_own_data_on :delete, :destroy
  it_should_authorize_access_own_data_on :patch,  :update

  it_should_protect_mass_assigment_on_create :name, :cost, :status, :note, :batch_no, ingredient_compositions_attributes: [:nutrient_id, :value, :id, :_destroy]
  it_should_protect_mass_assigment_on_update :name, :cost, :status, :note, :batch_no, ingredient_compositions_attributes: [:nutrient_id, :value, :id, :_destroy]

  it_should_behave_like_destory
  it_should_behave_like_index
  it_should_behave_like_new
  it_should_behave_like_edit
  it_should_behave_like_create
  it_should_behave_like_update
end
