class ItemsController < ApplicationController
  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      flash[:success] = "登録しました。"
      # redirect_to @item
    else
      render 'new'
    end
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :explanation
    )
  end
end
