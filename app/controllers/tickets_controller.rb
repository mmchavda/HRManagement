class TicketsController < ApplicationController
	require 'csv'

	before_action :find_ticket, only: [:show, :edit, :update, :destroy, :assign_ticket, :unassign_ticket, :resolve_ticket, :audit_history, :notes, :create_note]

	# Display all tickets
	def index
		if current_user.admin? || current_user.hr?
			@tickets = Ticket.all.order(created_at: :desc)
		elsif current_user.tl?
			# Show TL's own tickets and tickets created by users reporting to them
			team_member_ids = current_user.team_members.pluck(:id)
			@tickets = Ticket.where(user_id: [current_user.id] + team_member_ids).order(created_at: :desc)
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
			@tickets = @tickets.where(status: params[:status])
		end

		if params[:from_date].present?
			@tickets = @tickets.where("created_at >= ?", params[:from_date].to_date.beginning_of_day)
		end

		if params[:to_date].present?
			@tickets = @tickets.where("created_at <= ?", params[:to_date].to_date.end_of_day)
		end
		# ✅ Sorting logic
		sortable_columns = {
			"user" => "users.first_name",
			"title" => "tickets.title",
			"status" => "tickets.status",
			"priority" => "tickets.priority",
			"assigned_to" => "assigned_user.first_name"
		}
		if params[:sort].present? && sortable_columns.key?(params[:sort])
			direction = params[:direction].in?(%w[asc desc]) ? params[:direction] : "asc"
			if params[:sort] == "user"
				@tickets = @tickets.left_joins(:user).reorder("#{sortable_columns['user']} #{direction}")
			elsif params[:sort] == "assigned_to"
				@tickets = @tickets.left_joins(assigned_user: :assigned_tickets).reorder("#{sortable_columns['assigned_to']} #{direction}")
			else
				@tickets = @tickets.reorder("#{sortable_columns[params[:sort]]} #{direction}")
			end
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
    if current_user.tl?
			@ticket.approved = true # Automatically approve tickets created by TLs
		end

		begin
			if @ticket.save
				TicketMailer.notify_employee_and_tl(@ticket).deliver_now
				redirect_to @ticket, notice: "Ticket successfully created."
			else
				flash.now[:alert] = @ticket.errors.full_messages.join(", ")
				render :new
			end
		rescue => e
			flash.now[:alert] = "Error creating ticket: #{e.message}"
      render :new
		end
	
	end
  
	def edit
	rescue ActiveRecord::RecordNotFound => e
	  Rails.logger.error "Ticket not found: #{e.message}"
	  redirect_to tickets_path, alert: "Ticket not found"
	end
  
	def update
		begin 
			if @ticket.update(ticket_params)
        @employee = @ticket.user 
        @ticket.user = current_user
        if current_user.role == "admin" || current_user.role == "hr" || current_user.role == "operation_head"
          TicketMailer.notify_ticket_status(@ticket, @employee, current_user).deliver_now
        end
				redirect_to @ticket, notice: "Ticket successfully updated."
			else
				render :edit, alert: @ticket.errors.full_messages
			end
		rescue => e
			flash.now[:alert] = "Error updating ticket: #{e.message}"
      render :new
		end
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

	def approve
		ticket = Ticket.find(params[:id])

		# Ensure the current_user is the TL of the ticket creator
		if current_user == ticket.user.team_lead || current_user.admin? || current_user.hr? || current_user.operation_head?
			if ticket.update(approved: true)
				ticket.assign_hr_user_and_save
        TicketMailer.notify_employee_on_approval(ticket).deliver_now
				flash[:notice] = "Ticket approved and assigned to HR."
			end
		else
			flash[:alert] = "You are not authorized to approve this ticket."
		end

		redirect_to tickets_path
	end

  def reject
    ticket = Ticket.find(params[:id])

		if current_user == ticket.user.team_lead || current_user.admin? || current_user.hr? || current_user.operation_head?
			if ticket.update(approved: false, rejection_reason: params[:rejection_reason])
        TicketMailer.notify_employee_on_rejection(ticket).deliver_now
				flash[:notice] = "Ticket has been rejected."
      else
        redirect_to tickets_path, alert: "Failed to reject the ticket."
			end
		else
			flash[:alert] = "You are not authorized to approve this ticket."
		end

		redirect_to tickets_path
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
		params.require(:ticket).permit(:title, :description, :status, :priority, :category, :rejection_reason)
	end
end
  