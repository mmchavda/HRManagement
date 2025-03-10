class TicketsController < ApplicationController
	# Display all tickets
	def index
	  begin
		@tickets = Ticket.all
	  rescue => e
		Rails.logger.error "Error fetching tickets: #{e.message}"
		raise
	  end
	end
  
	# Show a specific ticket
	def show
	  @ticket = Ticket.find(params[:id])
	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	# Render form to create a new ticket
	def new
	  @ticket = Ticket.new
	end
  
	# Create a new ticket in the database
	def create
	  @ticket = Ticket.new(ticket_params)
	  @ticket.user = current_user
	  if @ticket.save
		redirect_to @ticket, notice: "Ticket successfully created."
	  else
		render :new, alert: "Error creating ticket."
	  end
	end
  
	# Render form to edit an existing ticket
	def edit
	  @ticket = Ticket.find(params[:id])
	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	# Update an existing ticket in the database
	def update
	  @ticket = Ticket.find(params[:id])
	  if @ticket.update(ticket_params)
		redirect_to @ticket, notice: "Ticket successfully updated."
	  else
		render :edit, alert: "Error updating ticket."
	  end
	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	# Delete a ticket from the database
	def destroy
	  @ticket = Ticket.find(params[:id])
	  if @ticket.destroy
		redirect_to tickets_path, notice: "Ticket successfully deleted."
	  else
		redirect_to tickets_path, alert: "Error deleting ticket."
	  end
	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	private
  
	# Strong parameters to prevent mass-assignment vulnerabilities
	def ticket_params
	  params.require(:ticket).permit(:title, :description, :status, :priority)
	end
  end
  