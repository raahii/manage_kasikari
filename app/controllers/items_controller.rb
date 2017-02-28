class ItemsController < ApplicationController
  before_action :set_item,       only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def index
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
      flash[:success] = "Item updated!"
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    Item.find(params[:id]).destroy
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

  # 正しいユーザーかどうか確認
  def correct_user
    unless current_user.id == @item.user_id
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end