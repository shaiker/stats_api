# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160809155658) do

  create_table "countries", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "match_events", :force => true do |t|
    t.integer  "match_id",             :null => false
    t.integer  "league_id",            :null => false
    t.integer  "season_id",            :null => false
    t.datetime "start_time"
    t.datetime "half_start_time"
    t.string   "status"
    t.integer  "round"
    t.integer  "team_id_home",         :null => false
    t.string   "team_name_home",       :null => false
    t.integer  "goals_home"
    t.integer  "goals_half_time_home"
    t.integer  "penalty_goals_home"
    t.integer  "team_id_away",         :null => false
    t.string   "team_name_away",       :null => false
    t.integer  "goals_away"
    t.integer  "goals_half_time_away"
    t.integer  "penalty_goals_away"
    t.integer  "team_id",              :null => false
    t.string   "type",                 :null => false
    t.integer  "minute"
    t.integer  "additional_minute"
    t.datetime "time"
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.string   "info"
    t.integer  "current_goals_home"
    t.integer  "current_goals_away"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "matches", :force => true do |t|
    t.integer  "league_id",            :null => false
    t.integer  "season_id",            :null => false
    t.datetime "start_time"
    t.datetime "half_start_time"
    t.string   "status"
    t.integer  "round"
    t.integer  "venue_id"
    t.integer  "team_id_home",         :null => false
    t.string   "team_name_home",       :null => false
    t.integer  "goals_home"
    t.integer  "goals_half_time_home"
    t.integer  "penalty_goals_home"
    t.integer  "team_id_away",         :null => false
    t.string   "team_name_away",       :null => false
    t.integer  "goals_away"
    t.integer  "goals_half_time_away"
    t.integer  "penalty_goals_away"
    t.integer  "shots_on_home"
    t.integer  "shots_off_home"
    t.integer  "shots_blocked_home"
    t.integer  "assists_home"
    t.integer  "cards_yellow_home"
    t.integer  "cards_red_home"
    t.integer  "corners_home"
    t.integer  "possession_home"
    t.integer  "fouls_home"
    t.integer  "shots_on_away"
    t.integer  "shots_off_away"
    t.integer  "shots_blocked_away"
    t.integer  "assists_away"
    t.integer  "cards_yellow_away"
    t.integer  "cards_red_away"
    t.integer  "corners_away"
    t.integer  "possession_away"
    t.integer  "fouls_away"
    t.string   "lineup_ids_home"
    t.text     "lineup_names_home"
    t.string   "bench_ids_home"
    t.text     "bench_names_home"
    t.string   "lineup_ids_away"
    t.text     "lineup_names_away"
    t.string   "bench_ids_away"
    t.text     "bench_names_away"
    t.integer  "remote_id",            :null => false
    t.string   "remote_source",        :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "matches", ["remote_id", "remote_source"], :name => "index_matches_on_remote_id_and_remote_source", :unique => true

  create_table "play_events", :force => true do |t|
    t.integer  "sport_id",   :null => false
    t.string   "sport_name"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "seasons", :force => true do |t|
    t.integer  "league_id",  :null => false
    t.string   "year",       :null => false
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "abbrev"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "teams", ["name"], :name => "index_teams_on_name"

  create_table "venues", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "city"
    t.string   "team_id"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
