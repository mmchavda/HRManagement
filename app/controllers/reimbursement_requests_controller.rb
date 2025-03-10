class ReimbursementRequestsController < ApplicationController
    before_action :set_reimbursement_request, only: %i[show edit update destroy]
  
    def index
      @reimbursement_requests = ReimbursementRequest.all
    end
  
    def show
    end
  
    def new
      @reimbursement_request = ReimbursementRequest.new
    end
  
    def create
      @reimbursement_request = ReimbursementRequest.new(reimbursement_request_params)
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
  
    private
  
    def set_reimbursement_request
      @reimbursement_request = ReimbursementRequest.find(params[:id])
    end
  
    def reimbursement_request_params
      params.require(:reimbursement_request).permit(:title, :amount, :status, :description)
    end
end
  