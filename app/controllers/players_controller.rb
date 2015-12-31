require 'being_lucky'
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

  def roll
    player = Player.find(params[:player_id])
    
    dice = Array.new(player.dice_left)
     
    # Generates numbers between 1 and 6 for all die, simulating a roll
    dice.map! {|x| Random.rand(1..6)}
    
    aposta = BeingLucky.new(dice)
    
    # Show the dice and roll score, for fun :)
    player.last_dice = dice
    player.last_turn = Time.new
    player.roll_score = aposta.score
    
    # For the next roll
    # If all of the thrown dice are scoring, then the player may roll all 5 dice on the next roll.
    player.dice_left = aposta.dice.count
    player.dice_left = 5 if player.dice_left == 0
        
    # You must have at least 300 to keep results
    player.turn_score += player.roll_score if player.turn_score >= 300 || player.roll_score >= 300 || player.score >= 300
        
    # If all of the thrown dice are scoring, then the player may roll all 5 dice on the next roll.
    player.dice_left = 5 if player.dice_left == 0
    
    # If a roll has zero points, then the player loses not only their turn,
    # but also accumulated score for that turn
    if player.roll_score == 0
      player.dice_left = 0    # Get out looser
      player.turn_score = 0
    end
    
    # Verify if the player may play on this turn
    player.able = (player.dice_left > 1)
    
    # Save 
    player.score = player.score + player.turn_score unless player.able

    player.save
    
    check_players
    
    render :json => player 
  end
  
  def enough
    player = Player.find(params[:player_id])
    player.score = player.score + player.turn_score
    player.able = false
    player.save
    
    check_players
    
    render :json => player 
  end
  
  private
  
  # Found a winner or begin a new turn
  def check_players
    lucky = Player.where('score >= ?', 3000).order(score: :desc).first
    if lucky
      lucky.winner = true
      lucky.save
      Player.where('id <> ?', winner.id).each do |player|
        player.able = false
        player.save
      end
      
    elsif Player.where(able: false).count == Player.count
      Player.all.each do |player|  
  			player.turn += 1
  			player.dice_left = 5
  			player.turn_score = 0
  			player.roll_score = 0
  			player.last_dice = '[0, 0, 0, 0, 0]'
  			player.able = true
  			player.save  
      end
    end
  end
  
  def safe_params
    params.permit(:able, :dice_left, :last_dice, :turn, :turn_score, :roll_score, :score, :name, :winner, :id, :player)
  end
end
