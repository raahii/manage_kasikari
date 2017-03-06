class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :friends, :items]
  before_action :logged_in_user, only: [:index, :edit, :update, :frinends]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @timeline_kasikaris = @user.timeline_kasikaris
    @new_kasis_count = @user.kasis.applying.count
    @new_karis_count = @user.karis.applying.count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Manage kasi kari!"
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def friends
    @users = @user.friends
    render 'show_friends'
  end

  def items
    @items = @user.items
    render 'show_items'
  end

  def notification
    @user      = current_user
    @new_kasikaris = @user.kasis.applying

    render 'show_notification'
  end

  private

  def user_params
    strong_params = params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :image,
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
