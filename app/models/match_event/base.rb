module MatchEvent
  class Base < ActiveRecord::Base
    self.table_name = 'match_events'
    def self.find_sti_class(type_name)
      type_name = self.name
      super
    end

    def self.sti_name 
      name.demodulize
    end    


    attr_accessible :match_id, :team_id, :minute, :additional_minute, :player1_id, :league_id, :season_id, :start_time, :half_start_time, :status, :round, :team_id_home, :team_name_home, :goals_home, :goals_half_time_home, :penalty_goals_home, :team_id_away, :team_name_away, :goals_away, :goals_half_time_away, :penalty_goals_away, :info, :time

    PLAY_EVENT_INFO_MAP = {
      17 => 'Penalty',
      28 => 'Own goal'
    }

    belongs_to :match

    def self.from_api_for_match(match)
	  	api = SoccerApi.new
			response = api.match_events_for_match(match.remote_id)

      match_data = response['league']['season']['eventType'].first['events'].first
      match.fill_match_data(match_data)

      match_data['periodDetails'].each do |period_data|
        match_events_from_data(match, period_data['goals'], 'Goal')
        match_events_from_data(match, period_data['yellowCards'], 'Card', { info: 'Yellow' })
        match_events_from_data(match, period_data['redCards'], 'Card', { info: 'Red' })
        match_events_from_data(match, period_data['substitutions'], 'Substitution')
      end

      match.fill_data_base_on_events
  	end

    def self.match_events_from_data(match, match_events_data, match_event_type, extra_attributes = nil)
      return if match_events_data.blank?
      match_events_data.each do |match_event_data|
        match_event = "MatchEvent::#{match_event_type}".constantize.find_or_init_from_data(match.id,  match_event_data)
        match_event.assign_attributes(match.attributes.with_indifferent_access.slice(:league_id, :season_id, :start_time, :half_start_time, :status, :round, :team_id_home, :team_name_home, :goals_home, :goals_half_time_home, :penalty_goals_home, :team_id_away, :team_name_away, :goals_away, :goals_half_time_away, :penalty_goals_away))
        match_event.assign_attributes(extra_attributes) if extra_attributes.present?
        match_event.match_event_from_data(match_event_data)
        match_event.current_goals_home = match.goals_for_side_at_time(:home, match_event.minute, match_event.additional_minute)
        match_event.current_goals_away = match.goals_for_side_at_time(:away, match_event.minute, match_event.additional_minute)
        match_event.time = (match_event.minute <= 45 ? match.start_time : match.half_start_time) + match_event.minute.minutes + match_event.additional_minute.minutes + match_event_data['time']['seconds']
        match_event.save!
      end
    end

    protected
    def self.find_or_init_from_data(match_id, match_event_data)
      self.find_or_initialize_by_match_id_and_team_id_and_minute_and_additional_minute_and_player1_id(match_id: match_id, team_id: match_event_data['team']['teamId'], minute: match_event_data['time']['minutes'], additional_minute: match_event_data['time']['additionalMinutes'], player1_id: match_event_data['player']['playerId'])
    end
  end
end