module MatchEvent
  class Substitution < Base
    
    def match_event_from_data(match_event_data)
      self.player2_id = match_event_data['playerIn']['playerId']
      self.info = "#{match_event_data['playerOut']['displayName']} Out - #{match_event_data['playerIn']['displayName']} In"
    end

    protected
    def self.find_or_init_from_data(match_id, match_event_data)
      self.find_or_initialize_by_match_id_and_event_team_id_and_minute_and_additional_minute_and_player1_id(match_id: match_id, event_team_id: match_event_data['team']['teamId'], minute: match_event_data['time']['minutes'], additional_minute: match_event_data['time']['additionalMinutes'], player1_id: match_event_data['playerOut']['playerId'])
    end    
  end
end