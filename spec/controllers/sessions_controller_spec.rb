require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'renders the new template for unauthenticated users' do
      get :new
      expect(response).to render_template :new
    end

    it 'redirects to home page if logged in' do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context 'with valid credentials' do
      let(:alice) { Fabricate(:user) }

      before do
        post :create, email: alice.email, password: alice.password
      end

      it 'sets the session user_id' do
        expect(session[:user_id]).to eq(alice.id)
      end

      it 'redirects to the home page' do
        expect(response).to redirect_to home_path
      end

      it 'sets a flash message' do
        expect(flash[:success]).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      let(:alice) { Fabricate(:user) }

      it 'does not set the session user_id' do
        post :create, email: alice.email, password: alice.password + "123"
        expect(session[:user_id]).to be_nil
      end

      it 'sets a flash message' do
        post :create, email: alice.email, password: alice.password + "123"
        expect(flash[:danger]).not_to be_nil
      end

      it_behaves_like "require sign in" do
        let(:action) { post :create, email: alice.email, password: alice.password + "123" }
      end
    end
  end

  describe 'GET destroy' do
    before do
      set_current_user
      post :destroy
    end

    it 'sets the session user_id to nil' do
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to root' do
      expect(response).to redirect_to root_path
    end

    it 'sets a flash message' do
      expect(flash[:success]).not_to be_nil
    end
  end
end