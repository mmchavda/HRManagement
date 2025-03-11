class DashboardController < ApplicationController
  def index
    @total_expenses = Expense.sum(:amount)
    @expenses_by_category = Expense.group(:category).sum(:amount)
    @pending_reimbursements = ReimbursementRequest.where(status: 'pending').count
    @approved_reimbursements = ReimbursementRequest.where(status: 'approved').count
    @rejected_reimbursements = ReimbursementRequest.where(status: 'rejected').count
    @total_reimbursements = ReimbursementRequest.sum(:total_amount)
    @recent_expenses = Expense.order(created_at: :desc).limit(5)

    @ticket_counts = Ticket.group(:status).count
    @recent_tickets = Ticket.order(created_at: :desc).limit(5)
  end
end

