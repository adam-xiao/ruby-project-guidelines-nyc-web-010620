class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.integer :away_id
      t.integer :home_id
      t.string :result
    end
  end
end
