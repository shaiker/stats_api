class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
    	t.integer :league_id, null: false
    	t.string  :year, null: false
    	t.string  :name

      t.timestamps
    end
  end
end
