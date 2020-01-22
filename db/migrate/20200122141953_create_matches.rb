class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string :blue_id
      t.string :red_id
      t.string :result
    end
  end
end
