class Match < ActiveRecord::Base
  attr_accessible :remote_id, :remote_source

  NO_GAME_STATUS = ['Postponed', 'Cancelled']

  def self.init_from_api_for_team_and_season(team, season)
  	begin
	  	api = SoccerApi.new
			response = api.matches_for_team_and_season(team.id, season.year_start)

			matches_data = response['league']['season']['eventType'].first['events']
			matches_data.each do |match_data|
				match = Match.find_or_initialize_by_remote_id_and_remote_source(remote_id: match_data['eventId'], remote_source: 'Stats')
				next if match.status == 'Final' || match_data['eventStatus']['name'].in?(NO_GAME_STATUS)

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
				# match.goals_half_time_home = #TODO

				away_team_data = match_data['teams'].find { |team_data| team_data['teamLocationType']['name'] == 'away' }
				match.team_id_away = away_team_data['teamId']
				match.team_name_away = away_team_data['displayName']
				match.goals_away = away_team_data['score']
				# match.goals_half_time_away = #TODO

				match.save!
			end
		rescue SoccerApi::DataNotFoundError => e
			puts "******* Cant find data for #{team.name} in season #{season.year}"
		end
	end  
end

# season = Season.last
# Team.find_each do |team|
# 	Match.init_from_api_for_team_and_season(team, season)
# 	sleep(2)
# end
