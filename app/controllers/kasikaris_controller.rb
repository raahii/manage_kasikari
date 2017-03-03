class KasikarisController < ApplicationController
  before_action :set_kasikari,   only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @kasikaris = Kasikari.paginate(page: params[:page])
  end

  def show
  end

  def new
    @kasikari = Kasikari.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_kasikari
    @kasikari = Kasikari.find(params[:id])
  end

  def kasikar_params
    params.require(:kasikari).permit(
      :item_id,
      :from_user_id,
      :to_user_id,
      :start_date,
      :end_date,
      :done_flag
    )
  end
end
