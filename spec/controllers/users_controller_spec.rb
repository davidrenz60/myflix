require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user to a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'redirects to home page if authenticated' do
      session[:user_id] = Fabricate(:user)
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'creates a new user' do
        expect(User.count).to eq(1)
      end

      it 'redirects to the sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'with invalid input' do
      before do
        post :create, user: { password: "1234", full_name: "Joe Smith" }
      end

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end
