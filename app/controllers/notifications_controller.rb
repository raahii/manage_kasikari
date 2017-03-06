class NotificationsController < ApplicationController
  def index
    @user = current_user
    @new_kasikaris = @user.kasis.applying.limit(20)
    #@new_followers = @user.followers.limit(10)
  end

  def read
    current_user.kasis.applying.unread.each(&:read!)
    #current_user.followers.unread.each{&:read!}
  end
end
