class ResetPasswordsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    redirect_to invalid_token_path unless user
  end
end