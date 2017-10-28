class AdminController < ApplicationController
  before_action :require_user, :require_admin

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You don't have access to do that."
      redirect_to home_path
    end
  end
end