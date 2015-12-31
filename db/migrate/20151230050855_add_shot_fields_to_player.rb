class AddShotFieldsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :turn, :integer, default: 0
    add_column :players, :turn_score, :integer, default: 0
    add_column :players, :roll_score, :integer, default: 0
    add_column :players, :dice_left, :integer, default: 5
    add_column :players, :last_turn, :timestamp
    add_column :players, :last_dice, :string, default: '[0, 0, 0, 0, 0]'
    add_column :players, :able, :boolean, default: true
    remove_column :players, :accumulator, :integer
  end
end
