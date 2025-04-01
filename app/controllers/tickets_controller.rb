class TicketsController < ApplicationController
	require 'csv'

	before_action :find_ticket, only: [:show, :edit, :update, :destroy, :assign_ticket, :unassign_ticket, :resolve_ticket, :audit_history, :notes, :create_note]

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
  
	def show
		@note = @ticket.notes.new
 	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	def new
	  @ticket = Ticket.new
	end
  
	def create
	  @ticket = Ticket.new(ticket_params)
	  @ticket.user = current_user
		hr_user = User.find_by_role(:hr)
		@ticket.assigned_user_id = hr_user.id
		@ticket.status = "open"
	  if @ticket.save
		  redirect_to @ticket, notice: "Ticket successfully created."
	  else
		  render :new, alert: @ticket.errors.full_messages
	  end
	end
  
	def edit
	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	def update
	  if @ticket.update(ticket_params)
		  redirect_to @ticket, notice: "Ticket successfully updated."
	  else
		  render :edit, alert: @ticket.errors.full_messages
	  end
	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	# Delete a ticket from the database
	def destroy 
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
		@ticket.assigned_user_id = params[:ticket][:assigned_user_id]
		if @ticket.save
			redirect_to tickets_path, notice: "Ticket successfully assigned."
		else
			redirect_to tickets_path, alert: "Error assigning ticket."
		end
	end 

	def unassign_ticket
		@ticket.assigned_user_id = nil
		if @ticket.save
			redirect_to tickets_path, notice: "Ticket successfully unassigned."
		else
			redirect_to tickets_path, alert: "Error unassigning ticket."
		end
	end

	def resolve_ticket
		@ticket.status = "resolved"
		if @ticket.save
			redirect_to tickets_path, notice: "Ticket successfully resolved."
		else
			redirect_to tickets_path, alert: "Error resolving ticket."
		end
	end

	def export_csv
    @tickets = Ticket.all

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Title', 'Description', 'Status', 'Created At', 'Updated At']
      
      @tickets.each do |ticket|
        csv << [ticket.id, ticket.title, ticket.description, ticket.status, ticket.created_at, ticket.updated_at]
      end
    end

    send_data csv_data, filename: "tickets_#{Date.today}.csv", type: 'text/csv', disposition: 'attachment'
  end

	def audit_history
	end

	def notes
	end

	def create_note
		@note = @ticket.notes.new(note_params)
    @note.user = current_user  # Assuming you want to associate the note with the logged-in user

    if @note.save
      # Redirect to the ticket show page after successfully creating the note
      redirect_to ticket_path(@ticket), notice: 'Note was successfully added.'
    else
      # Handle validation errors and return to ticket show page with errors
      redirect_to ticket_path(@ticket), alert: 'Failed to add note.'
    end
  end
  
	private

		def note_params
			params.require(:note).permit(:content)
		end

	  def find_ticket
		  @ticket = Ticket.find(params[:id])
			if @ticket.nil?
				redirect_to tickets_path, alert: "Ticket not found"
			end
		end 	

		def ticket_params
			params.require(:ticket).permit(:title, :description, :status, :priority)
		end
  end
  