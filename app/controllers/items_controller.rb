class ItemsController < ApplicationController
  before_action :set_item,       only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def index
    @items = current_user.items
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      flash[:success] = "登録しました。"
      redirect_to @item
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      flash[:success] = "アイテムを更新しました"
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    @item.destroy
    flash[:success] = "アイテムを削除しました。"
    redirect_to user_path(current_user)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :name,
      :explanation,
      :image
    )
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    unless current_user.id == @item.user_id
      redirect_to root_url
    end
  end
end
