class ExpensesController < ApplicationController
    before_action :set_expense, only: %i[show edit update destroy]
    require 'csv'

    def index
      if current_user.admin? || current_user.hr?  
        @expenses = Expense.all.order(created_at: :desc)
      else 
        @expenses = current_user.expenses.order(created_at: :desc)
      end 
      
      if params[:search].present?
        term = "%#{params[:search]}%"
        @expenses = @expenses.left_joins(:user).where("title LIKE :term OR users.first_name LIKE :term OR users.last_name LIKE :term", term: "%#{params[:search]}%")      
      end

      if params[:category].present?
        @expenses = @expenses.where(category: params[:category])
      end

      @expenses = @expenses&.page(params[:page]).per(10)
    end
  
    def show
    end
  
    def new
      @expense = Expense.new
    end
  
    def create
      @expense = Expense.new(expense_params)
			@expense.user = current_user
      begin
        if @expense.save
          redirect_to @expense, notice: 'Expense was successfully created.'
        else
          render :new, alert: "Error creating ticket."
        end
      rescue => e
        flash.now[:alert] = "Error creating expense: #{e.message}"
        render :new
      end
    end
  
    def edit
    end

    def update
      # Only attach new files, don’t replace old ones
      new_files = expense_params[:proofs]
      begin
        if @expense.update(expense_params.except(:proofs))
          # Only attach if new files are actually provided
          if new_files.is_a?(Array)
            new_files.each do |file|
              @expense.proofs.attach(file)
            end
          end
          redirect_to edit_expense_path(@expense), notice: "Expense was successfully updated."
        else
          render :edit
        end
      rescue => e
        flash.now[:alert] = "Error updating expense: #{e.message}"
        render :new
      end
    end
  
    def destroy
      @expense.destroy
      redirect_to expenses_url, notice: 'Expense was successfully deleted.'
    end

    def export_csv
      if params[:start_date].present? && params[:end_date].present?
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        @expense = Expense.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      else
        @expense = Expense.all
      end

      csv_data = CSV.generate(headers: true) do |csv|
        csv << ['ID', 'User', 'Amount', 'Description', 'Date', 'Category', 'Created At', 'Updated At']
        
        @expense.each do |expense|
          csv << [expense.id, expense.user.email, expense.amount, expense.description, expense.date,expense.category, expense.created_at, expense.updated_at]
        end
      end
  
      send_data csv_data, filename: "expenses_#{Date.today}.csv", type: 'text/csv', disposition: 'attachment'
    end
    
    def remove_proof
      expense = Expense.find(params[:id])
      file = ActiveStorage::Blob.find(params[:proof_id]) rescue nil

      if file.nil?
        head :not_found and return
      end

      attachment = expense.proofs.attachments.find_by(blob_id: file.id)

      if attachment
        attachment.purge
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to expense_path(expense), notice: "File removed." }
          format.json { render json: { success: true } }
        end
      else
        head :not_found
      end
    end

    private
  
    def set_expense
      @expense = Expense.find(params[:id])
    end
  
    def expense_params
      params.require(:expense).permit(:title, :amount, :category, :description, :date, proofs: [])
    end
end
  
