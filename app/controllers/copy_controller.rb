class CopyController < ApplicationController

  def create
    params[:klass].constantize.create_like params[:id].to_i
    flash[:success] = "#{params[:klass]} copied."
    redirect_to url_for(controller: params[:klass].underscore.pluralize, action: :index)
  end

end
