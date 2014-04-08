require 'spec_helper'

describe FormulasController do

  let(:assign_klass) { assigns :formula } # used by controller macros
  let(:klass_attributes) {
    { 
      "name"=>"Layer 0-3 wks", 
      "batch_size"=>"2000.0000", 
      "note"=>"", 
      "formula_ingredients_attributes"=>[
        {"ingredient_id"=>"50", "_destroy"=>"false", "ingredient_cost"=>"0.95",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"4"}, 
        {"ingredient_id"=>"53", "_destroy"=>"false", "ingredient_cost"=>"12.0",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"5"}, 
        {"ingredient_id"=>"63", "_destroy"=>"false", "ingredient_cost"=>"0.065", "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"6"},
        {"ingredient_id"=>"59", "_destroy"=>"false", "ingredient_cost"=>"6.0",   "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"7"}, 
        {"ingredient_id"=>"60", "_destroy"=>"false", "ingredient_cost"=>"7.8",   "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"8"}, 
        {"ingredient_id"=>"61", "_destroy"=>"false", "ingredient_cost"=>"72.0",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"9"}, 
        {"ingredient_id"=>"66", "_destroy"=>"false", "ingredient_cost"=>"2.28",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"10"},
        {"ingredient_id"=>"67", "_destroy"=>"false", "ingredient_cost"=>"1.7",   "min_perc"=>"0.4000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"11"}, 
        {"ingredient_id"=>"70", "_destroy"=>"false", "ingredient_cost"=>"2.75",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"12"}, 
        {"ingredient_id"=>"72", "_destroy"=>"false", "ingredient_cost"=>"16.0",  "min_perc"=>"3.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"13"}, 
        {"ingredient_id"=>"73", "_destroy"=>"false", "ingredient_cost"=>"0.6",   "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"14"}, 
        {"ingredient_id"=>"76", "_destroy"=>"false", "ingredient_cost"=>"1.1",   "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"15"}, 
        {"ingredient_id"=>"78", "_destroy"=>"false", "ingredient_cost"=>"2.22",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"16"}, 
        {"ingredient_id"=>"79", "_destroy"=>"false", "ingredient_cost"=>"1.9",   "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"17"}, 
        {"ingredient_id"=>"81", "_destroy"=>"false", "ingredient_cost"=>"0.55",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"18"}, 
        {"ingredient_id"=>"83", "_destroy"=>"false", "ingredient_cost"=>"5.6",   "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"19"},
        {"ingredient_id"=>"84", "_destroy"=>"false", "ingredient_cost"=>"38.0",  "min_perc"=>"0.0000", "use"=>"true", "max_perc"=>"0.0000", "actual_perc"=>"0.0", "shadow" => "9.0", "weight" => "555", "unpermitted"=>"0.0", "id"=>"20"}
      ], 
      "formula_nutrients_attributes"=>[
        {"nutrient_id"=>"78", "_destroy"=>"false",  "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"264"}, 
        {"nutrient_id"=>"79", "_destroy"=>"false",  "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"265"}, 
        {"nutrient_id"=>"81", "_destroy"=>"false",  "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"266"},
        {"nutrient_id"=>"82", "_destroy"=>"false",  "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"267"}, 
        {"nutrient_id"=>"83", "_destroy"=>"false",  "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"268"},
        {"nutrient_id"=>"87", "_destroy"=>"false",  "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"269"}, 
        {"nutrient_id"=>"88", "_destroy"=>"false",  "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"270"}, 
        {"nutrient_id"=>"103", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"271"}, 
        {"nutrient_id"=>"105", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"272"}, 
        {"nutrient_id"=>"106", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"273"},
        {"nutrient_id"=>"111", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"274"}, 
        {"nutrient_id"=>"110", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"275"},
        {"nutrient_id"=>"112", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"276"}, 
        {"nutrient_id"=>"119", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"277"}, 
        {"nutrient_id"=>"118", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"278"}, 
        {"nutrient_id"=>"120", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"279"},
        {"nutrient_id"=>"131", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"280"}, 
        {"nutrient_id"=>"133", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"281"},
        {"nutrient_id"=>"134", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"282"}, 
        {"nutrient_id"=>"136", "_destroy"=>"false", "min"=>"0.0000", "max"=>"0.0000", "use"=>"true", "actual"=>"0.0", "unpermitted"=>"0.0", "id"=>"283"}
      ]
    }
  }

  it_should_be_authenticated_on :post,   :create
  it_should_be_authenticated_on :get,    :new
  it_should_be_authenticated_on :get,    :edit,    id: 3
  it_should_be_authenticated_on :delete, :destroy, id: 3
  it_should_be_authenticated_on :patch,  :update,  id: 9
  it_should_be_authenticated_on :get,    :index

  it_should_authorize_access_own_data_on :get,    :edit
  it_should_authorize_access_own_data_on :delete, :destroy
  it_should_authorize_access_own_data_on :patch,  :update

  it_should_protect_mass_assigment_on_create :name, :batch_size, :note, :cost, formula_nutrients_attributes: [:id, :_destroy, :nutrient_id, :max, :min, :actual, :use], formula_ingredients_attributes: [:id, :_destroy, :ingredient_id, :ingredient_cost, :max_perc, :min_perc, :actual_perc, :shadow, :weight, :use]
  it_should_protect_mass_assigment_on_update :name, :batch_size, :note, :cost, formula_nutrients_attributes: [:id, :_destroy, :nutrient_id, :max, :min, :actual, :use],formula_ingredients_attributes: [:id, :_destroy, :ingredient_id, :ingredient_cost, :max_perc, :min_perc, :actual_perc, :shadow, :weight, :use]

  it_should_behave_like_index
  it_should_behave_like_destory
  it_should_behave_like_new
  it_should_behave_like_edit
  it_should_behave_like_create
  it_should_behave_like_update

  it "PUT :calculate"
  it "POST :calculate"

end
