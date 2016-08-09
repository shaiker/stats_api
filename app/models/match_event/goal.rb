module MatchEvent
	class Goal < Base

    def match_event_from_data(match_event_data)
      self.player2_id = match_event_data['assistingPlayer']['playerId'] if match_event_data['assistingPlayer'].present?
      self.info = PLAY_EVENT_INFO_MAP[match_event_data['playEvent']['playEventId'].to_i] || match_event_data['playEvent']['name']
    end

	end
end
