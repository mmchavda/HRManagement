class TicketsController < ApplicationController
	require 'csv'

	# Display all tickets
	def index
		if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?	
	    @tickets = Ticket.all
		else
			@tickets = current_user.created_tickets
		end	

		if params[:status].present?
      @tickets = @tickets.where(status: params[:status]).page(params[:page]).per(10)
    end
    
		@tickets = @tickets.page(params[:page]).per(10)

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
	def destroy #soft_delete
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

	def assign_ticket
		@ticket = Ticket.find(params[:id])
		@ticket.assigned_user_id = current_user.id
		if @ticket.save
			redirect_to tickets_path, notice: "Ticket successfully assigned."
		else
			redirect_to tickets_path, alert: "Error assigning ticket."
		end
	end 

	def unassign_ticket
		@ticket = Ticket.find(params[:id])
		@ticket.assigned_user_id = nil
		if @ticket.save
			redirect_to tickets_path, notice: "Ticket successfully unassigned."
		else
			redirect_to tickets_path, alert: "Error unassigning ticket."
		end
	end

	def resolve_ticket
		@ticket = Ticket.find(params[:id])
		@ticket.status = "resolved"
		if @ticket.save
			redirect_to tickets_path, notice: "Ticket successfully resolved."
		else
			redirect_to tickets_path, alert: "Error resolving ticket."
		end
	end

	def export_csv
    # Get the tickets you want to export, for example, all tickets
    @tickets = Ticket.all

    # Create the CSV data
    csv_data = CSV.generate(headers: true) do |csv|
      # Add the headers (column names)
      csv << ['ID', 'Title', 'Description', 'Status', 'Created At', 'Updated At']
      
      # Add ticket data
      @tickets.each do |ticket|
        csv << [ticket.id, ticket.title, ticket.description, ticket.status, ticket.created_at, ticket.updated_at]
      end
    end

    # Send the CSV as a download
    send_data csv_data, filename: "tickets_#{Date.today}.csv", type: 'text/csv', disposition: 'attachment'
  end
  
	private
  
	# Strong parameters to prevent mass-assignment vulnerabilities
	def ticket_params
	  params.require(:ticket).permit(:title, :description, :status, :priority)
	end
  end
  