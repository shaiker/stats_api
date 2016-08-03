class PlayEvent < ActiveRecord::Base
  attr_accessible :id, :name, :sport_id, :sport_name

  def self.init_from_api
  	api = SoccerApi.new
  	response = api.decode('playEvents')

  	response['league']['playEvents'].each do |play_event|
  		PlayEvent.find_or_create_by_id_and_sport_id(id: play_event['playEventId'], name: play_event['name'], sport_id: response['sportId'], sport_name: response['name'])
  	end
  end

end
