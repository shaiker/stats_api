class Player < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.init_from_api(since_year)
  	api = SoccerApi.new
  	response = api.players(since_year)

  	response['league']['players'].each do |player_data|
  		player = Player.find_or_initialize_by_id(id: player_data['playerId'])
      player.id = player_data['playerId']
  		player.first_name = player_data['firstName']
  		player.last_name = player_data['lastName']
  		player.display_name = player_data['displayName']
      player.team_id = player_data['team']['teamId'] if player_data['team'].present?
  		player.save!
  	end
  end

end
