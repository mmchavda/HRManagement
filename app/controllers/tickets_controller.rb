class TicketsController < ApplicationController
	require 'csv'

	before_action :find_ticket, only: [:show, :edit, :update, :destroy, :assign_ticket, :unassign_ticket, :resolve_ticket, :audit_history, :notes, :create_note]

	# Display all tickets
	def index
		if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?	
	    @tickets = Ticket.all.order(created_at: :desc)
		else
			@tickets = current_user.created_tickets.order(created_at: :desc)
		end	
		
		if params[:search].present?
			term = "%#{params[:search]}%"
			@tickets = @tickets.left_joins(:user).where("tickets.title LIKE :term OR tickets.description LIKE :term OR users.first_name LIKE :term OR users.last_name LIKE :term", term: term)

			if Ticket.priorities.key?(params[:search])
				@tickets = @tickets.or(Ticket.where(priority: params[:search]))
			end

			if Ticket.statuses.key?(params[:search])
				@tickets = @tickets.or(Ticket.where(status: params[:search]))
			end
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
			redirect_to @ticket, notice: "Ticket successfully assigned."
		else
			redirect_to @ticket, alert: "Error assigning ticket."
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
		if params[:start_date].present? && params[:end_date].present?
			start_date = Date.parse(params[:start_date])
			end_date = Date.parse(params[:end_date])
			@tickets = Ticket.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
		else
			@tickets = Ticket.all
		end
		
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

	def new_note
    @ticket = Ticket.find(params[:id])
    @note = @ticket.notes.new
  end

  def create_note
		@note = @ticket.notes.new(note_params)
    @note.user = current_user 
    if @note.save
      redirect_to @ticket
    else
      render :show
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
  