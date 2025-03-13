class ExpensesController < ApplicationController
    before_action :set_expense, only: %i[show edit update destroy]
  
    def index
      if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
        @expenses = Expense.all.page(params[:page]).per(10)
      else 
        @expenses = current_user.expenses.page(params[:page]).per(10)
      end   
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
  
    private
  
    def set_expense
      @expense = Expense.find(params[:id])
    end
  
    def expense_params
      params.require(:expense).permit(:title, :amount, :category, :description, :date, :proof)
    end
end
  
