class Venue < ActiveRecord::Base
  attr_accessible :id, :name, :city, :team_id, :country_id
end
