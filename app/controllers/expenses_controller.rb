class ExpensesController < ApplicationController
    before_action :set_expense, only: %i[show edit update destroy]
    require 'csv'

    def index
      if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
        @expenses = Expense.all
      else 
        @expenses = current_user.expenses
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
      if @expense.save
        redirect_to @expense, notice: 'Expense was successfully created.'
      else
				render :new, alert: "Error creating ticket."
      end
    end
  
    def edit
    end
  
    def update
      if @expense.update(expense_params)
        redirect_to @expense, notice: 'Expense was successfully updated.'
      else
        render :edit
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
  
  
    private
  
    def set_expense
      @expense = Expense.find(params[:id])
    end
  
    def expense_params
      params.require(:expense).permit(:title, :amount, :category, :description, :date, :proof)
    end
end
  
