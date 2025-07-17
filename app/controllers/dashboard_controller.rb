class DashboardController < ApplicationController
  # require 'net/http'
  # require 'uri'
  # require 'json'
  require 'net/http'
  require 'uri'
  require 'json'

  skip_before_action :verify_authenticity_token, only: [:get_embed_info]

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

  def open
    @entered_email = params[:email]
  end


  def get_embed_info
    data = JSON.parse(request.body.read)
    email = data["email"]
    uri = URI("https://embedcustomerdashboard-bhh5fhbre8ftepf7.canadacentral-01.azurewebsites.net/getembedinfo")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    req.body = { email: email }.to_json
    res = http.request(req)
    if res.is_a?(Net::HTTPSuccess)
      render json: JSON.parse(res.body)
    else
      render json: { error: "Failed to fetch embed info" }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

 
end
