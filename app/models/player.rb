class Player < ActiveRecord::Base
  
  def new_turn
    self.turn = self.turn + 1
    self.turn_score = 0
    self.roll_score = 0
    self.dice = 5
  end
    
end
