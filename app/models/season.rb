class Season < ActiveRecord::Base
  # attr_accessible :title, :body

  def year_start
  	year.split('-').first.strip.to_i
  end
end
