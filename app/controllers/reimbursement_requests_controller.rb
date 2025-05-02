class ReimbursementRequestsController < ApplicationController
    before_action :set_reimbursement_request, only: %i[show edit update destroy approve_request reject_request audit_history update_status]
    skip_before_action :verify_authenticity_token, only: [:reject_request]  # TEMP ONLY!

  	require 'csv'

    def index
      if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
        @reimbursement_requests = ReimbursementRequest.all
      else 
        @reimbursement_requests = current_user.reimbursement_requests
      end   

      if params[:search].present?
        term = "%#{params[:search]}%"
        @reimbursement_requests = @reimbursement_requests.left_joins(expense: :user).where("expenses.title LIKE :term OR users.first_name LIKE :term OR users.last_name LIKE :term", term: "%#{params[:search]}%")      
      end

      if params[:status].present?
        @reimbursement_requests = @reimbursement_requests.where(status: params[:status])
      end

      @reimbursement_requests = @reimbursement_requests&.page(params[:page]).per(10)
    end
  
    def show
    end
  
    def new
      @reimbursement_request = ReimbursementRequest.new
    end
  
    def create
      @reimbursement_request = ReimbursementRequest.new(reimbursement_request_params)
      @reimbursement_request.total_amount = @reimbursement_request.expense&.amount
      if @reimbursement_request.save
        redirect_to @reimbursement_request, notice: 'Reimbursement request was successfully created.'
      else
        flash.now[:alert] = @reimbursement_request.errors.full_messages.to_sentence
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if params[:reimbursement_request][:status] == 'approved'
        @reimbursement_request.approved_at = Date.today
        @reimbursement_request.approved_by = current_user.id
      end  

      if @reimbursement_request.update(reimbursement_request_params)
        redirect_to @reimbursement_request, notice: 'Reimbursement request was successfully updated.'
      else
        flash.now[:alert] = @reimbursement_request.errors.full_messages.to_sentence
        render :edit
      end
    end
  
    def destroy
      begin
        @reimbursement_request.destroy
        redirect_to reimbursement_requests_url, notice: 'Reimbursement request was successfully deleted.'
      rescue => e
        redirect_to reimbursement_requests_url, alert: "Error deleting reimbursement request: #{e.message}"
      end
    end

    def approve_request
      begin
        if @reimbursement_request.status == 'approved'
          redirect_to reimbursement_requests_url, alert: 'This request is already approved.'
        else
          @reimbursement_request.approve!
          redirect_to reimbursement_requests_url, notice: 'Reimbursement request was successfully approved.'
        end
      rescue => e
        redirect_to reimbursement_requests_url, alert: "Error approving reimbursement request: #{e.message}"
      end
    end

    # def reject_request
    #   begin
    #     if @reimbursement_request.status == 'rejected'
    #       redirect_to reimbursement_requests_url, alert: 'This request is already rejected.'
    #     else
    #       @reimbursement_request.reject!
    #       redirect_to reimbursement_requests_url, notice: 'Reimbursement request was successfully rejected.'
    #     end
    #   rescue => e
    #     redirect_to reimbursement_requests_url, alert: "Error rejecting reimbursement request: #{e.message}"
    #   end
    # end

    def update_status
      if @reimbursement_request.update(status: params[:status])
        # Handle success (redirect to index or show page, for example)
        redirect_to reimbursement_requests_path, notice: 'Reimbursement request status updated successfully.'
      else
        # Handle failure (you may want to render an error or re-render the index page)
        redirect_to reimbursement_requests_path, alert: 'Failed to update status.'
      end
    end

    def reject_request
      begin
        @reimbursement_request = ReimbursementRequest.find(params[:request_id])
        reason = params[:reason]
      
        if reason.blank?
          flash[:alert] = "Rejection reason is required."
          redirect_back fallback_location: reimbursement_requests_path
          return
        end
      
        if @reimbursement_request.update(status: :rejected, rejection_reason: reason)
          flash[:notice] = "Reimbursement request rejected successfully."
          redirect_to reimbursement_requests_path
        else 
          flash[:alert] = @reimbursement_request.errors.full_messages.to_sentence
          redirect_back fallback_location: reimbursement_requests_path
        end  
      rescue => e
        redirect_to reimbursement_requests_url, alert: "Error rejecting reimbursement request: #{e.message}"
      end
    end

    def export_csv
      begin
        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date])
          end_date = Date.parse(params[:end_date])
          @reimbursement_requests = ReimbursementRequest.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
        else
          @reimbursement_requests = ReimbursementRequest.all
        end
        
        csv_data = CSV.generate(headers: true) do |csv|
          csv << ['ID', 'Amount', 'Status', 'Created At', 'Updated At']
  
          @reimbursement_requests.each do |request|
            csv << [request.id, request.total_amount, request.status, request.created_at, request.updated_at]
          end
        end
  
        send_data csv_data, filename: "reimbursement_requests_#{Date.today}.csv", type: 'text/csv', disposition: 'attachment'
      rescue => e
        flash[:alert] = "Error generating CSV: #{e.message}"
        redirect_to reimbursement_requests_url
      end
    end

    def audit_history
    end
  
    private
  
    def set_reimbursement_request
      @reimbursement_request = ReimbursementRequest.find_by_id(params[:id])
    end
  
    def reimbursement_request_params
      params.require(:reimbursement_request).permit(:total_amount, :status, :expense_id, :manager_id, :rejection_reason)
    end
end
  