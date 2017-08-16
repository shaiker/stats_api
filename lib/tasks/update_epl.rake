task :update_epl => :environment do
  season = Season.where(league_id: 39).order('year').last
  time = Time.now
  Team.find_each do |team|
    Match.from_api_for_team_and_season(team, season)
    sleep(2)
  end
    
  new_matches = Match.where(season_id: season.id).where("created_at >= ?", time)
  # puts "Fetched #{new_matches.size} Matches. Now bringing their data and cleanup"
  new_matches.each do |match|
    if match.status == 'Final'
      MatchEvent::Base.from_api_for_match(match)
      sleep(2)
    end
  end
end