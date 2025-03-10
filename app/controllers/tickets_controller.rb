class TicketsController < ApplicationController
  def index 
	begin
		@tickets = Ticket.all
	  rescue => e
		Rails.logger.error "Error fetching tickets: #{e.message}"
		raise
	  end
  end 
end
