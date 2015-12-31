class BeingLucky
  attr_reader :dice
  
  def initialize(dice)
    @dice = dice
  end
  
  # Calculate the points allocated based on the results of the doll
  # Dice that generate a score are removed and any non-scoring may be used again
  #
  # Score Logic
  # ---------------------------
  #   Three 1's -> 1000 points
  #   Three 6's ->  600 points
  #   Three 5's ->  500 points
  #   Three 4's ->  400 points
  #   Three 3's ->  300 points
  #   Three 2's ->  200 points
  #   One   1   ->  100 points
  #   One   5   ->   50 points
  # ---------------------------
  #
  # A single die can only be counted once in each roll.
  # For example, a "5" can only count as part of a triplet
  # (contributing to the 500 points) or as a single 50 points,
  # but not both in the same roll.
  #
  # @return [Integer] the point total for this round
  def score
    points = 0
    
    # Make the sum frequency of each face
    frequency = Hash[@dice.group_by {|face| face}.map {|f,v| [f, v.count]}]
    
    frequency.each do |face, count|
      # Sum triplet and non-triplent situations
      if count > 2
        points += triplet(face) + non_triplet(face, count - 3)
      else
        points += non_triplet(face, count)
      end
    end
    points
  end
  
  private
  
  def triplet(num)
    @dice.pop(3)
    num == 1 ? 1000 : num * 100
  end

  # Just 1 and 5 are special, they may be in both status
  def non_triplet(num, non_triplet_count)
    if num == 1 and non_triplet_count > 0
      @dice.pop(non_triplet_count)
      non_triplet_count * 100
    elsif num == 5 and non_triplet_count > 0
      @dice.pop(non_triplet_count)
      non_triplet_count * 50
    else
      0
    end
  end
  
end