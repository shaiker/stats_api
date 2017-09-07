task :update_epl => :environment do
  $redis.hset('update_matches', 'status', 'Fetching')
  season = Season.where(league_id: 39).order('year').last
  time = Time.now
  updated_matches = []
  Team.find_each do |team|
    updated_matches += Match.from_api_for_team_and_season(team, season)
    sleep(2)
  end
    
  # puts "Fetched #{new_matches.size} Matches. Now bringing their data and cleanup"
  updated_matches.each do |match|
    if match.status == 'Final'
      MatchEvent::Base.from_api_for_match(match)
      sleep(2)
    end
  end
  $redis.hset('update_matches', 'updated', Time.now.to_i)
  $redis.hset('update_matches', 'status', 'Finished')
end