class SoccerApi

	PREMIER_LEAGUE_PATH = 'epl'
	SPORT = 'soccer'
	API_KEY = 'vngphcrb2743vk8vjyb5t2be'
	API_SECRET = 'azy4uXYJhM'

	ENDPOINT_BASE = 'http://api.stats.com/v1'
	# DECODE_TYPES = ['playEvents']

	def initialize(api_key = API_KEY, api_secret = API_SECRET, leaguePath = PREMIER_LEAGUE_PATH)
		@api_key = api_key
		@api_secret = api_secret
		@leaguePath = leaguePath
	end

	def decode(type)
		make_request("/decode/#{SPORT}/#{@leaguePath}/#{type.to_s}/")
	end

	def teams(season)
		make_request("/stats/#{SPORT}/#{@leaguePath}/teams/", { season: season })
	end

	def matches_for_team_and_season(team_id, season)
		make_request("/stats/#{SPORT}/#{@leaguePath}/events/teams/#{team_id}", { season: season })
	end

	private 
	def make_request(endpoint, params = {})
		params = params.merge({
			api_key: @api_key,
			sig: generate_request_signature
		})

		uri =  URI.parse("#{ENDPOINT_BASE}#{endpoint}")
		uri.query = URI.encode_www_form(params)
		response = Net::HTTP.get_response(uri)
		raise DataNotFoundError.new if response.code == '404'
		JSON.parse(response.body)['apiResults'].first
	end

	def generate_request_signature
		Digest::SHA256.hexdigest(@api_key + @api_secret + Time.now.utc.to_i.to_s)
	end

	class DataNotFoundError < StandardError; end

end