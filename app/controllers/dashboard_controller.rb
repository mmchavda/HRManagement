class DashboardController < ApplicationController

  def index
    # debugger
    if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
      @total_expenses = Expense.sum(:amount)
      @expenses_by_category = Expense.group(:category).sum(:amount)
      @pending_reimbursements = ReimbursementRequest.where(status: 'pending').count
      @total_reimbursements = ReimbursementRequest.sum(:total_amount)
      @recent_expenses = Expense.order(created_at: :desc).limit(5)
      @recent_reimbursements = ReimbursementRequest.order(created_at: :desc).limit(5)
      @ticket_counts = Ticket.group(:status).count
      @recent_tickets = Ticket.order(created_at: :desc).limit(5)
      @pending_tickets = Ticket.where(status: 'pending').count
    elsif current_user.employee?
      @total_reimbursements = current_user.reimbursement_requests.sum(:total_amount)
      @recent_expenses = current_user.expenses.order(created_at: :desc).limit(5)
      @ticket_counts = current_user.created_tickets.group(:status).count
      @recent_tickets = current_user.created_tickets.order(created_at: :desc).limit(5)
      @recent_reimbursements = current_user.reimbursement_requests.order(created_at: :desc).limit(5)

      @pending_tickets = current_user.created_tickets.where(status: 'pending').count
      @pending_reimbursements = current_user.reimbursement_requests.where(status: 'pending').count
      @expenses = current_user.expenses
      @reimbursement_requests = current_user.reimbursement_requests
      @tickets = current_user.created_tickets
      @assigned_tickets = current_user.assigned_tickets
    end   
  end

  def edit
    @user = current_user  # Edit current user profile
  end

  def update
    @user = current_user  # Get the current user
    if @user.update(user_params)  # Update user with the params
      redirect_to dashboard_path, notice: 'Profile updated successfully'
    else
      render :edit, status: :unprocessable_entity  # If there's an error, render the edit form again
    end
  end

  def show 
    @user = User.find(params[:id])
  end 

  private

  def user_params
    # Allow these fields to be updated
    params.require(:user).permit(:first_name, :last_name, :username, :bio, :phone_number, :dob, :avatar, :is_active, :gender, :blood_group, :address)
  end
end
