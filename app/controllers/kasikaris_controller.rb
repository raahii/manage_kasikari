class KasikarisController < ApplicationController
  before_action :set_kasikari,   only: [:show, :edit, :update, :destroy, :permit, :reject, :done]
  before_action :set_choices, only: [:edit]
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :correct_item,   only: [:new_with_item]
  before_action :ajax_correct_user, only: [:permit, :reject, :done]

  def index
    @kasikaris = Kasikari.paginate(page: params[:page])
  end

  def show
  end

  def new
    delete_item_session
    @kasikari = Kasikari.new
    set_choices
  end
  
  # newアクションの時に、「特定の値は埋めて表示させる」ということはできない
  # urlでitem_idを渡すしかないので、アクションも分けるしか無い ?
  def new_with_item
    set_item_session
    @from_user = User.find_by(id: @item.owner.id)
    @to_user   = current_user
    @kasikari = Kasikari.new(
      item_id:      @item.id,
      from_user_id: @from_user.id,
      to_user_id:   @to_user.id,
    )

    render 'new_with_item'
  end

  def create
    @kasikari = Kasikari.new(kasikari_params)
    
    # 借りたいボタンから来た場合にそのアイテムidが記録されているのでそれで判断
    if @kasikari.save
      delete_item_session
      flash[:success] = "貸し借りを登録しました"
      redirect_to @kasikari
    else
      set_choices
      if session[:with_item].present?
        render 'new_with_item' and return
      else
        render 'new' and return
      end
    end
  end

  def edit
  end

  def update
    if @kasikari.update_attributes(kasikari_params)
      @kasikari.item.update_attributes!(available: !@kasikari.ongoing?)
  
      if params[:ajax_action]
        head :no_content and return
      else
        flash[:success] = "貸し借りを更新しました"
        redirect_to @kasikari
      end
    else
      set_choices
      debugger
      render 'edit'
    end
  end

  def destroy
    @kasikari.destroy
    @kasikari.item.update_attributes!(available: true)
    flash[:success] = "貸し借りを削除しました。"
    redirect_to user_path(current_user)
  end

  def permit
    if @kasikari.update_attributes(status: "ongoing")
      head :no_content
    else
      render json: {
        error: @kasikari.errors.full_messages,
        status: 400
      }
    end
  end

  def reject
    if @kasikari.update_attributes(status: "denied")
      head :no_content
    else
      render json: {
        errors: @kasikari.errors.full_messages,
        status: 400
      }
    end
  end

  def done
    if @kasikari.update_attributes(status: "done")
      head :no_content
    else
      render json: {
        error: @kasikari.errors.full_messages,
        status: 400
      }
    end
  end

  private

  def set_kasikari
    @kasikari = Kasikari.find(params[:id])
  end

  def set_item_session
    session[:with_item] = true
  end

  def delete_item_session
    session.delete(:with_item) if session[:with_item].present?
  end

  def kasikari_params
    _params = params.require(:kasikari)
    
    [:start_date, :end_date].each do |attr|
      if _params[attr].present?
        _params[attr] = Date.parse(_params[attr]) rescue nil
      end
    end

    _params.permit(
      :item_id,
      :from_user_id,
      :to_user_id,
      :start_date,
      :end_date,
      :status,
    )
  end

  # 正しいユーザーかどうか確認
  def correct_user
    friends   = current_user.friends
    from_user = @kasikari.from_user
    to_user   = @kasikari.to_user

    if ![from_user, to_user].include?(current_user)
      flash[:danger] = "貸し借りにあなたが含まれていません"
      redirect_to new_kasikari_path
    elsif from_user == current_user && to_user == current_user
      flash[:danger] = "貸し借りをするユーザーの組み合わせが無効です"
      redirect_to new_kasikari_path
    elsif !friends.include?(from_user) && !friends.include?(to_user)
      flash[:danger] = "友達でないユーザーとの貸し借りはできません"
      redirect_to new_kasikari_path
    end
  end

  def correct_item
    @item = Item.find(params[:id])
    if current_user?(@item.owner)
      redirect_to root_path
    elsif !current_user.friend_with?(@item.owner)
      redirect_to root_path
    end
  end

  def set_choices
    @user      = current_user
    @friends   = current_user.friends
    @from_user = @kasikari.from_user
    @to_user   = @kasikari.to_user
    @item      = @kasikari.item
  end

  def ajax_correct_user
    if @kasikari.from_user != current_user
      render json: {
        error: "invalid user",
        status: 400
      }
    end
  end
end
