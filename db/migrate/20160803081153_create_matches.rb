class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
    	t.integer   :league_id, null: false
    	t.integer   :season_id, null: false
    	t.datetime  :start_time
    	t.datetime  :half_start_time
    	t.string 		:status
    	t.integer		:round
    	t.integer		:venue_id

    	t.integer		:team_id_home, null: false
    	t.string 		:team_name_home, null: false
    	t.integer 	:goals_home
    	t.integer 	:goals_half_time_home
    	t.integer 	:penalty_goals_home

    	t.integer		:team_id_away, null: false
    	t.string 		:team_name_away, null: false
    	t.integer 	:goals_away
    	t.integer 	:goals_half_time_away
    	t.integer 	:penalty_goals_away

    	t.integer 	:shots_on_home
    	t.integer 	:shots_off_home
    	t.integer 	:shots_blocked_home
    	t.integer		:assists_home
    	t.integer		:cards_yellow_home
    	t.integer		:cards_red_home
    	t.integer		:corners_home
    	t.integer		:possession_home
    	t.integer		:fouls_home

    	t.integer 	:shots_on_away
    	t.integer 	:shots_off_away
    	t.integer 	:shots_blocked_away
    	t.integer		:assists_away
    	t.integer		:cards_yellow_away
    	t.integer		:cards_red_away
    	t.integer		:corners_away
    	t.integer		:possession_away
    	t.integer		:fouls_away

    	t.string 		:lineup_ids_home
    	t.text			:lineup_names_home
    	t.string		:bench_ids_home
    	t.text			:bench_names_home

    	t.string 		:lineup_ids_away
    	t.text			:lineup_names_away
    	t.string		:bench_ids_away
    	t.text			:bench_names_away

    	t.integer 	:remote_id, null: false
    	t.string		:remote_source, null: false

      t.timestamps
    end

    add_index :matches, [:remote_id, :remote_source], unique: true
  end
end
