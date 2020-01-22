class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|    
      t.string :summoner_name
      t.string :summoner_id
    end
  end
end
