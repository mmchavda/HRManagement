class DashboardController < ApplicationController

  def index
    # debugger
    if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
      @total_expenses = Expense.sum(:amount)
      @recent_expenses = Expense.order(created_at: :desc).limit(5)
      @recent_reimbursements = ReimbursementRequest.order(created_at: :desc).limit(5)
      @recent_tickets = Ticket.order(created_at: :desc).limit(5)
      @expenses = Expense.all
      @tickets = Ticket.all
      @reimbursements = ReimbursementRequest.all
    elsif current_user.employee?
      @recent_expenses = current_user.expenses.order(created_at: :desc).limit(5)
      @recent_tickets = current_user.created_tickets.order(created_at: :desc).limit(5)
      @recent_reimbursements = current_user.reimbursement_requests.order(created_at: :desc).limit(5)
      @expenses = current_user.expenses
      @reimbursements = current_user.reimbursement_requests
      @tickets = current_user.created_tickets
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

  def reports 
    
  end 

  private

  def user_params
    # Allow these fields to be updated
    params.require(:user).permit(:first_name, :last_name, :username, :bio, :phone_number, :dob, :avatar, :is_active, :gender, :blood_group, :address, :role)
  end
end
