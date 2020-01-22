class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :Player1
      t.string :Player2
      t.string :Player3
      t.string :Player4
      t.string :Player5
    end
  end
end