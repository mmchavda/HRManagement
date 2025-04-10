class ReimbursementRequestsController < ApplicationController
    before_action :set_reimbursement_request, only: %i[show edit update destroy approve_request reject_request audit_history]
  	require 'csv'

    def index
      if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
        @reimbursement_requests = ReimbursementRequest.all
      else 
        @reimbursement_requests = current_user.reimbursement_requests
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

    def reject_request
      begin
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
        @reimbursement_requests = ReimbursementRequest.all
        # Create the CSV data
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
      @reimbursement_request = ReimbursementRequest.find(params[:id])
    end
  
    def reimbursement_request_params
      params.require(:reimbursement_request).permit(:total_amount, :status, :expense_id, :manager_id)
    end
end
  