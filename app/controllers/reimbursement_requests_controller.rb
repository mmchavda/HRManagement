class ReimbursementRequestsController < ApplicationController
    before_action :set_reimbursement_request, only: %i[show edit update destroy]
  
    def index
      if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
        @reimbursement_requests = ReimbursementRequest.all
      else 
        @reimbursement_requests = current_user.reimbursement_requests
      end   
    end
  
    def show
    end
  
    def new
      @reimbursement_request = ReimbursementRequest.new
    end
  
    def create
      @reimbursement_request = ReimbursementRequest.new(reimbursement_request_params)
      @reimbursement_request.total_amount = @reimbursement_request.expense.amount
      if @reimbursement_request.save
        redirect_to @reimbursement_request, notice: 'Reimbursement request was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @reimbursement_request.update(reimbursement_request_params)
        redirect_to @reimbursement_request, notice: 'Reimbursement request was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @reimbursement_request.destroy
      redirect_to reimbursement_requests_url, notice: 'Reimbursement request was successfully deleted.'
    end

    def approve_request
      @reimbursement_request = ReimbursementRequest.find(params[:id])
      @reimbursement_request.approve!
      redirect_to reimbursement_requests_url, notice: 'Reimbursement request was successfully approved.'
    end

    def reject_request
      @reimbursement_request = ReimbursementRequest.find(params[:id])
      @reimbursement_request.reject!
      redirect_to reimbursement_requests_url, notice: 'Reimbursement request was successfully rejected.'
    end
  
    private
  
    def set_reimbursement_request
      @reimbursement_request = ReimbursementRequest.find(params[:id])
    end
  
    def reimbursement_request_params
      params.require(:reimbursement_request).permit(:total_amount, :status, :expense_id, :manager_id)
    end
end
  