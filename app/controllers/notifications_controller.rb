class NotificationsController < ApplicationController
  def index
    @user = current_user
    @new_kasikaris = @user.kasis.applying.limit(20)
    @new_followers = @user.friends - @user.followers.limit(10)
  end

  def read
    current_user.kasis.applying.unread.each(&:read!)
  end
end
