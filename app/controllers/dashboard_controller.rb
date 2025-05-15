class DashboardController < ApplicationController

  def index
    if current_user.admin? || current_user.hr?  
      @total_expenses = Expense.sum(:amount)
      @recent_expenses = Expense.order(created_at: :desc).limit(5)
      @recent_reimbursements = ReimbursementRequest.order(created_at: :desc).limit(5)
      @recent_tickets = Ticket.order(created_at: :desc).limit(5)
      @expenses = Expense.all
      @tickets = Ticket.all
      @reimbursements = ReimbursementRequest.all
      @recent_assets = Asset.order(created_at: :desc).limit(5)
      @assets = Asset.all
    elsif current_user.employee?
      @recent_expenses = current_user.expenses.order(created_at: :desc).limit(5)
      @recent_tickets = current_user.created_tickets.order(created_at: :desc).limit(5)
      @recent_reimbursements = current_user.reimbursement_requests.order(created_at: :desc).limit(5)
      @expenses = current_user.expenses
      @reimbursements = current_user.reimbursement_requests
      @tickets = current_user.created_tickets
      @assets = Asset.joins(:asset_assignments)
               .where(asset_assignments: { user_id: current_user.id, active: true })

      @recent_assets = @assets.order(created_at: :desc).limit(5)
    end   
  end

  def reports 
    
  end 
 
end
