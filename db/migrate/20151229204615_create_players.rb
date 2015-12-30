class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string  :name
      t.integer :score, default: 0
      t.boolean :accumulator
      t.boolean :winner

      t.timestamps null: false
    end
  end
end
