class SettingsController < ApplicationController
  before_filter :authenticate_user!

  def profile
    @user = current_user
    @title = t "title.set_profile"
  end

  def profile_p
    @user = current_user
    if @user.update_without_password(params[:user])
      redirect_to settings_profile_path, :notice => t(:update_profile_success)
    else
      redirect_to settings_profile_path, :alert => t(:update_profile_failed)
    end
  end

  def password
    @user = current_user
    @title = t "title.set_password"
  end

  def password_p
    @user = current_user
    if @user.update_with_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to settings_password_path, :notice => t(:update_password_success)
    else
      redirect_to settings_password_path, :alert => t(:update_password_failed)
    end
  end
end
