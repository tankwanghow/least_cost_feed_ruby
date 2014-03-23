module ControllerMacros
  extend ActiveSupport::Concern

  module ClassMethods
    def it_should_behave_like_update
      context "PATCH :update" do
        before(:each) do
          user = create(:user)
          @klass_instance = create(klass_sym, user_id: user.id)
          login_as user
          params =  { id: @klass_instance.id, "#{klass_sym}" => @klass_instance.attributes }
          patch :update, params
        end
        it { expect(assign_klass).to eq @klass_instance }
        it { expect(response).to render_template :edit }
      end

      context "PATCH :update, save success" do
        before(:each) do
          dbl = double
          user = create(:user)
          @klass_instance = create(klass_sym, user_id: user.id)
          login_as user
          params =  { id: @klass_instance.id, "#{klass_sym}" => @klass_instance.attributes }
          expect(controller.current_user).to receive(klass_sym.to_s.pluralize).and_return dbl
          expect(dbl).to receive(:find).and_return @klass_instance
          patch :update, params
        end        
        it { expect(assign_klass).to eq @klass_instance}
        it { expect(flash[:success]).to include "success" }
      end

      context "PATCH :update, save fail" do
        before(:each) do
          dbl = double
          user = create(:user)
          @klass_instance = create(klass_sym, user_id: user.id)
          @invalid_klass_attributes = attributes_for("invalid_#{klass_sym}")
          login_as user
          params =  { id: @klass_instance.id, "#{klass_sym}" => @klass_instance.attributes }
          expect(controller.current_user).to receive(klass_sym.to_s.pluralize).and_return dbl
          expect(dbl).to receive(:find).and_return @klass_instance
          patch :update, params
        end        
        it { expect(assign_klass).to eq @klass_instance}
        it { expect(flash[:success]).to include "success" }
      end      
    end

    def it_should_behave_like_create
      context "POST :create" do
        before(:each) do
          @user = create(:user)
          klass_instance = build(klass_sym)
          login_as @user
          params =  { "#{klass_sym}" => klass_instance.attributes }
          post :create, params
        end
        it { expect(assign_klass.class).to be klass }
        it { expect(assign_klass.user_id).to eq @user.id }
      end
        
      context "POST :create, save success" do
        before(:each) do
          user = create(:user)
          klass_instance = build(klass_sym)
          login_as user 
          params =  { "#{klass_sym}" => klass_instance.attributes }
          post :create, params
        end
        it { expect(flash[:success]).to include 'success' }
        it { expect(response).to redirect_to redirect_to send("#{klass_sym.to_s.pluralize}_path")  }
      end

      context "POST :create, save fail" do
        before(:each) do
          user = create(:user)
          klass_invalid_instance = build("invalid_" + klass_sym.to_s)
          login_as user 
          params =  { "#{klass_sym}" => klass_invalid_instance.attributes }
          post :create, params
        end
        it { expect(flash[:danger]).to include 'fail' }
        it { expect(response).to render_template :new }
      end
    end
    
    def it_should_behave_like_edit
      context "GET :edit" do
        before(:each) do
          user = create(:user)
          @klass_instance = create(klass_sym, user_id: user.id)
          login_as user
          get :edit, id: @klass_instance.id
        end
        it { expect(assign_klass.class).to be klass }
        it { expect(assign_klass).to eq @klass_instance }
        it { expect(response).to render_template :edit }
      end 
    end

    def it_should_behave_like_new
      context "GET :new" do
        before(:each) do
          user = create(:user)
          login_as user
          get :new
        end
        it { expect(assign_klass.class).to be klass }
        it { expect(assign_klass).to be_new_record }
        it { expect(response).to render_template :new }
      end 
    end

    def it_should_behave_like_destory
      context "DELETE :destroy" do
        before(:each) do
          user = create(:user)
          klass_instance = create(klass_sym, user_id: user.id)
          login_as user
          delete :destroy, id: klass_instance.id
        end
        it { expect(assign_klass.destroyed?).to be_true }
        it { expect(flash[:success]).to include "success" }
        it { expect(response).to redirect_to send("#{klass_sym.to_s.pluralize}_path") }
      end
    end

    def it_should_authorize_access_own_data_on http_method, action
      it "#{http_method.upcase} :#{action} should not allow access other user data" do
        user = create :user
        other = create :user
        klass_instance = create(klass_sym, user_id: other.id)
        login_as user
        params = { id: klass_instance.id, "#{klass_sym}" => klass_instance.attributes }
        do_request http_method, action, params
        expect(response).to redirect_to :root
        expect(flash[:danger]).not_to be_blank
      end

      it "#{http_method.upcase} :#{action} should allow access user own data" do
        user = create :user
        other = create :user
        klass_instance = create(klass_sym, user_id: user.id)
        login_as user
        params = { id: klass_instance.id, "#{klass_sym}" => klass_instance.attributes }
        do_request http_method, action, params
        expect(assign_klass).to eq klass_instance
      end
    end

    def it_should_protect_mass_assigment_on_create *permitted_param_keys
      it "POST :create should protect mass-assigment" do
        user = create :user
        login_as user
        klass_instance = build(klass_sym)
        klass.should_receive(:new).with(permitted_params(klass_instance.attributes, permitted_param_keys)).and_return klass_instance
        params = { "#{klass_sym}" => klass_instance.attributes }
        do_request :post, :create, params
      end
    end

    def it_should_protect_mass_assigment_on_update *permitted_param_keys
      it "PATCH :update should protect mass-assigment" do
        dbl = double
        user = create :user
        login_as user
        klass_instance = create(klass_sym, user_id: user.id)
        params = { id: klass_instance.id, "#{klass_sym}" => klass_instance.attributes }
        expect(controller.current_user).to receive(klass_sym.to_s.pluralize).and_return dbl
        expect(dbl).to receive(:find).and_return klass_instance
        klass_instance.should_receive(:update).with(permitted_params(klass_instance.attributes, permitted_param_keys)).and_return klass_instance
        do_request :patch, :update, params
      end
    end


    def it_should_be_authenticated_on http_method, action, params=nil
      it "#{http_method.upcase} :#{action} should be authenticated" do
        do_request http_method, action, params
        expect(response).to redirect_to :login
      end
    end  

    def it_should_not_be_authenticated_on http_method, action, params=nil
      it "#{http_method.upcase} :#{action} should be authenticated" do
        do_request http_method, action, params
        expect(response).not_to redirect_to :login
      end
    end  
  end

  def klass
    controller.class.name.sub("Controller", "").singularize.constantize
  end

  def klass_sym
    controller.class.name.sub("Controller", "").singularize.underscore.to_sym
  end

  def permitted_params params, keys
    keys.map! { |t| t.to_s }
    params.select do |k, v|
      keys.include? k.to_s 
    end.map do |k, v|
      [k, [TrueClass, FalseClass].include?(v.class) ? v : v.to_s ]
    end.to_h
  end

  def do_request http_method, action, params
    if http_method == :get
      get action, params
    elsif http_method == :post
      post action, params
    elsif http_method == :patch
      patch action, params
    elsif http_method == :put
      put action, params
    elsif http_method == :delete
      delete action, params
    else
      raise "HTTP METHOD #{http_method} not found"
    end
  end

end