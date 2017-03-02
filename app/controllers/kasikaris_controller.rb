class KasikarisController < ApplicationController
  def index
    @kasikaris = Kasikari.paginate(page: params[:page])
  end

  def new

  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
