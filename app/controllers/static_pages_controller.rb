class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @item  = current_user.items.build
      @timeline_kasikaris = current_user.timeline_kasikaris
    end
  end
end
