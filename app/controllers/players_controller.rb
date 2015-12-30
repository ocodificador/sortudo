class PlayersController < ApplicationController
  respond_to :json

  def index
    render :json => Player.all
  end

  def show
    respond_with Player.find(params[:id])
  end

  def create
    render :json => Player.create(name:params[:name])
  end

  def update
    render :json =>  Player.update(safe_params[:id], safe_params)
  end

  def destroy
    render :json =>  Player.destroy(params[:id])
  end
  
  private
  
  def safe_params
    params.permit(:score, :name, :winner, :id, :player)
  end
end
