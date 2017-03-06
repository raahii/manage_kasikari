class NotificationsController < ApplicationController
  def index
    @user = current_user
    @new_kasikaris = @user.kasis.applying
    @new_followers = @user.followers
  end
end
