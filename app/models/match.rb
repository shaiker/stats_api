class Match < ActiveRecord::Base
  attr_accessible :remote_id, :remote_source

  NO_GAME_STATUS = ['Postponed', 'Cancelled']


  def self.from_api_for_team_and_season(team, season)
    updated_matches = []
  	begin
	  	api = SoccerApi.new
			response = api.matches_for_team_and_season(team.id, season.year_start)

			matches_data = response['league']['season']['eventType'].first['events']
			matches_data.each do |match_data|
				match = Match.find_or_initialize_by_remote_id_and_remote_source(remote_id: match_data['eventId'], remote_source: 'Stats')
				next if match.status == 'Final' # || match_data['eventStatus']['name'].in?(NO_GAME_STATUS)

				match.league_id = response['league']['leagueId']
				match.season_id = season.id
				match.status = match_data['eventStatus']['name']
				match.venue_id = match_data['venue']['venueId']
				match.round = match_data['week']
				match.start_time = Time.parse("#{match_data['startDate'][1]['full']} UTC")
				# match.half_start_time = #TODO

				home_team_data = match_data['teams'].find { |team_data| team_data['teamLocationType']['name'] == 'home' }
				match.team_id_home = home_team_data['teamId']
				match.team_name_home = home_team_data['displayName']
				match.goals_home = home_team_data['score']

				away_team_data = match_data['teams'].find { |team_data| team_data['teamLocationType']['name'] == 'away' }
				match.team_id_away = away_team_data['teamId']
				match.team_name_away = away_team_data['displayName']
				match.goals_away = away_team_data['score']

				match.save!
        updated_matches << match
			end
  	rescue SoccerApi::DataNotFoundError => e
  		puts "******* Cant find data for #{team.name} in season #{season.year}"
  	end
    return updated_matches
	end

	def fill_match_data(match_data)
    home_team_data = match_data['teams'].find { |team_data| team_data['teamLocationType']['name'] == 'home' }
    self.goals_half_time_home = home_team_data['linescores'].find { |ls| ls['period'] == 1 }['score']

    away_team_data = match_data['teams'].find { |team_data| team_data['teamLocationType']['name'] == 'away' }
    self.goals_half_time_away = away_team_data['linescores'].find { |ls| ls['period'] == 1 }['score']

    home_team_data = match_data['boxscores'].find { |team_data| team_data['teamId'].to_i == self.team_id_home }
    self.shots_on_home = home_team_data['teamStats']['shotsOnGoal']
    self.shots_blocked_home = home_team_data['teamStats']['shots']['blocked'] || 0
    self.shots_off_home = home_team_data['teamStats']['shots']['total'] - self.shots_on_home - self.shots_blocked_home
    self.corners_home =  home_team_data['teamStats']['cornerKicks']
    self.possession_home = home_team_data['teamStats']['possessionPercentage']
    self.fouls_home = home_team_data['teamStats']['foulsCommitted']

    away_team_data = match_data['boxscores'].find { |team_data| team_data['teamId'].to_i == self.team_id_away }
    self.shots_on_away = away_team_data['teamStats']['shotsOnGoal']
    self.shots_blocked_away = away_team_data['teamStats']['shots']['blocked'] || 0
    self.shots_off_away = away_team_data['teamStats']['shots']['total'] - self.shots_on_away - self.shots_blocked_away
    self.corners_away =  away_team_data['teamStats']['cornerKicks']
    self.possession_away = away_team_data['teamStats']['possessionPercentage']
    self.fouls_away = away_team_data['teamStats']['foulsCommitted']

    home_lineup_data = home_team_data['players'].select { |player| player['isGameStarted'] }
    self.lineup_ids_home = home_lineup_data.map { |p| p['player']['playerId'] }.join(',')
    self.lineup_names_home = home_lineup_data.map { |p| p['player']['displayName'] }.join(',')

    away_lineup_data = away_team_data['players'].select { |player| player['isGameStarted'] }
    self.lineup_ids_away = away_lineup_data.map { |p| p['player']['playerId'] }.join(',')
    self.lineup_names_away = away_lineup_data.map { |p| p['player']['displayName'] }.join(',')

    home_bench_data = home_team_data['benchPlayers']
    self.bench_ids_home = home_bench_data.map { |p| p['player']['playerId'] }.join(',')
    self.bench_names_home = home_bench_data.map { |p| p['player']['displayName'] }.join(',')

    away_bench_data = away_team_data['benchPlayers']
    self.bench_ids_away = away_bench_data.map { |p| p['player']['playerId'] }.join(',')
    self.bench_names_away = away_bench_data.map { |p| p['player']['displayName'] }.join(',')

    first_half_finish = match_data['pbp'].find { |match_event| match_event['period'].to_i == 1 && match_event['playEvent']['name'] == 'Half Over' }
    self.half_start_time = start_time + 45.minutes + (first_half_finish['time']['additionalMinutes'].to_i + 1).minutes + 15.minutes

    save!
	end

	def goals_for_side_at_time(side, minute, additional_minute = 0)
		team_id = side == :home ? team_id_home : team_id_away
		MatchEvent::Goal.where(match_id: id, event_team_id: team_id).where("minute <= ? AND additional_minute <= ?", minute, additional_minute).count
	end

	def fill_data_base_on_events
		self.assists_home = MatchEvent::Goal.where(match_id: id, event_team_id: team_id_home).where('player2_id IS NOT NULL').count
		self.assists_away = MatchEvent::Goal.where(match_id: id, event_team_id: team_id_away).where('player2_id IS NOT NULL').count

    self.cards_red_home = MatchEvent::Card.where(match_id: id, event_team_id: team_id_home).where('info like "%Red%"').count
    self.cards_red_away = MatchEvent::Card.where(match_id: id, event_team_id: team_id_away).where('info like "%Red%"').count

    self.cards_yellow_home = MatchEvent::Card.where(match_id: id, event_team_id: team_id_home).where('info in ("Yellow", "Second Yellow Card")').count
    self.cards_yellow_away = MatchEvent::Card.where(match_id: id, event_team_id: team_id_away).where('info in ("Yellow", "Second Yellow Card")').count

		save!
	end
end

# season = Season.last
# Team.find_each do |team|
# 	Match.init_from_api_for_team_and_season(team, season)
# 	sleep(2)
# end

# Match.where('id >= 776').where(remote_source: 'Stats').find_each do |match| 
# 	MatchEvent::Base.from_api_for_match(match)
# 	sleep(2)
# end
