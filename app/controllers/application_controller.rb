class ApplicationController < ActionController::Base
  protect_from_forgery

  def ping
    render text: 'pong'
  end
end
