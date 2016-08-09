class CreateMatchEvents < ActiveRecord::Migration
  def change
    create_table :match_events do |t|

      t.integer   :match_id, null: false
      t.integer   :league_id, null: false
      t.integer   :season_id, null: false
      t.datetime  :start_time
      t.datetime  :half_start_time
      t.string    :status
      t.integer   :round

      t.integer   :team_id_home, null: false
      t.string    :team_name_home, null: false
      t.integer   :goals_home
      t.integer   :goals_half_time_home
      t.integer   :penalty_goals_home

      t.integer   :team_id_away, null: false
      t.string    :team_name_away, null: false
      t.integer   :goals_away
      t.integer   :goals_half_time_away
      t.integer   :penalty_goals_away

      t.integer   :team_id, null: false
      t.string    :type, null: false
      t.integer   :minute
      t.integer   :additional_minute
      t.datetime  :time
      t.integer   :player1_id
      t.integer   :player2_id
      t.string    :info

      t.integer   :current_goals_home
      t.integer   :current_goals_away


      t.timestamps
    end
  end
end
