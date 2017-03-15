class KasikarisController < ApplicationController
  before_action :set_kasikari,   only: [:show, :edit, :update, :destroy, :permit, :reject, :done]
  before_action :set_choices, only: [:edit]
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :correct_item,   only: [:new_kari]
  before_action :ajax_correct_user, only: [:permit, :reject, :done]

  def index
    @kasikaris = Kasikari.paginate(page: params[:page])
  end

  def show
  end

  def new
    @kasikari = Kasikari.new
    @user = current_user
    @friends = current_user.friends
  end

  def new_kari
    @from_user = User.find_by(id: @item.owner.id)
    @to_user   = current_user
    @kasikari = Kasikari.new(
      item_id:      @item.id,
      from_user_id: @from_user.id,
      to_user_id:   @to_user.id,
    )

    session[:create_kari] = @item.id

    render 'new_with_item'
  end

  def create
    @kasikari = Kasikari.new(kasikari_params)
    
    # new_kariから来た場合にそのアイテムidが記録されているのでそれで判断
    if @kasikari.save
      session.delete(:create_kari) if @item
      flash[:success] = "貸し借りを登録しました"
      redirect_to @kasikari
    else
      if session[:create_kari].present?
        @item      = Item.find_by(id: session[:create_kari])
        @from_user = User.find_by(id: @item.owner.id)
        @to_user   = current_user
        render 'new_with_item' and return
      else
        @user      = current_user
        @friends   = current_user.friends
        @from_user = @kasikari.from_user
        @to_user   = @kasikari.to_user
        @item      = @kasikari.item
        render 'new' and return
      end
    end
  end

  def edit
  end

  def update
    if @kasikari.update_attributes(kasikari_params)
      @kasikari.item.update_attributes!(available: !@kasikari.ongoing?)
      flash[:success] = "貸し借りを更新しました"
      redirect_to @kasikari
    else
      set_choices
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

  def kasikari_params
    _params = params.require(:kasikari)
    
    [:start_date, :end_date].each do |attr|
      _params[attr] = Date.parse(_params[attr]) rescue nil
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
