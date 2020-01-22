class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :duration_minutes
      t.float :efficiency_difference
    end
  end
end
