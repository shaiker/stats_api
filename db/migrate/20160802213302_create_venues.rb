class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
    	t.string :name, null: false
    	t.string :city
    	t.string :team_id
    	t.integer :country_id

      t.timestamps
    end
  end
end
