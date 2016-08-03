class CreatePlayEvents < ActiveRecord::Migration
  def change
    create_table :play_events do |t|
    	t.integer :sport_id, null: false
    	t.string	:sport_name
    	t.string	:name

      t.timestamps
    end
  end
end
