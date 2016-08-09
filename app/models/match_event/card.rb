module MatchEvent
	class Card < Base

		after_create :create_second_yellow_card

    def match_event_from_data(match_event_data)
      if self.info == 'Red' && match_event_data['bookingType']['name'] == "Second Yellow Card"
      	self.info = 'Red - Second Yellow Card'
      	# second_yellow_data = match_event_data.merge({ 'bookingType' => { 'name' => "Yellow - Second Card", "bookingTypeId" => 1 } })
      	# MatchEvent::Base.match_events_from_data(match, [ second_yellow_data ], 'Card', { info: "Yellow - Second Card" })
      end
    end

    def create_second_yellow_card
    	if info == 'Red - Second Yellow Card'
    		second_yellow = dup
    		second_yellow.update_attributes({ info: "Yellow - Second Card", time: time - 1.second })
    	end
    end

    # protected
    # def self.find_or_init_from_data(match_id, match_event_data)
    #   self.find_or_initialize_by_match_id_and_team_id_and_minute_and_additional_minute_and_player1_id(match_id: match_id, team_id: match_event_data['team']['teamId'], minute: match_event_data['time']['minutes'], additional_minute: match_event_data['time']['additionalMinutes'], player1_id: match_event_data['player']['playerId'], info: match_event_data['bookingType']['name'])
    # end

  end
end