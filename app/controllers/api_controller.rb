class ApiController < ApplicationController
  
  def update_matches
    system "cd #{Rails.root} & bundle exec rake update_epl --trace 2>&1 >> #{Rails.root}/log/rake.log &"
    render nothing: true 
  end
  
end
