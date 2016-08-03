class Team < ActiveRecord::Base
  attr_accessible :id, :name, :abbrev

  def self.init_from_api(season)
  	api = SoccerApi.new
		response = api.teams(season)

		teams_array = response['league']['season']['conferences'].first['divisions'].first['teams']
		teams_array.each do |team_data|
			team = Team.find_or_create_by_id(id: team_data['teamId'], name: team_data['displayName'], abbrev: team_data['abbreviation'])
			venue_data = team_data['venue']			
			Venue.find_or_create_by_id(id: venue_data['venueId'], name: venue_data['name'], city: venue_data['city'], team_id: team_data['teamId'], country_id: team_data['country']['countryId'])
		end
  end
end
