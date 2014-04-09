require 'spec_helper'

describe CopyController do

  it_should_be_authenticated_on :post, :create

  it 'POST create' do
    login_as create :user
    f = create :formula
    expect(f.class).to receive(:create_like).with(f.id)
    post :create, id: f.id, klass: f.class.name
    expect(flash[:success]).to include "copied"
    expect(response).to redirect_to "/#{f.class.name.underscore.pluralize}"
  end

end