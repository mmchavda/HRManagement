class AssetsController < ApplicationController
  # app/controllers/assets_controller.rb
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_asset, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
      @assets = Asset.all.includes(:asset_category, :notes)
    else
      @assets = Asset.joins(:asset_assignments)
                     .where(asset_assignments: { user_id: current_user.id, active: true })
                     .includes(:asset_category, :notes)
                     .distinct
    end

    if params[:status].present?
      @assets = @assets.where(status: params[:status])
    end

    if params[:search].present?
      term = "%#{params[:search].downcase}%"
      @assets = @assets
      .left_joins(:asset_category)
      .left_joins(asset_assignments: :user)
      .where(
        "LOWER(assets.name) LIKE :term
         OR LOWER(assets.unique_id) LIKE :term
         OR LOWER(users.first_name) LIKE :term
         OR LOWER(users.last_name) LIKE :term
         OR LOWER(asset_categories.name) LIKE :term",
        term: term
      ).distinct
    end
    @assets = @assets.page(params[:page]).per(10)
  end

  def new
    @asset = Asset.new
    @asset_categories = AssetCategory.all
  end

  def create
    @asset = Asset.new(asset_params)
    
    if @asset.save
      redirect_to @asset, notice: 'Asset was successfully created.'
    else
      @asset_categories = AssetCategory.all
      render :new, alert: "Error creating asset."
    end
  end

  def edit
    @asset_categories = AssetCategory.all
  end

  def update
    if @asset.update(asset_params)
      redirect_to assets_path, notice: 'Asset was successfully updated.'
    else
      @asset_categories = AssetCategory.all
      render :edit
    end
  end

  def destroy
    @asset.destroy
    redirect_to assets_path, notice: 'Asset was successfully deleted.'
  end

  def show
    if current_user.admin? || current_user.hr? || current_user.manager? || current_user.lead?
      @notes = @asset.notes
      @users = User.all
      @asset_assignment = @asset.asset_assignments.find_by(active: true) || @asset.asset_assignments.build
    else
      unless @asset.asset_assignments.exists?(user_id: current_user.id, active: true)
        redirect_to assets_path, alert: 'You are not authorized to view this asset.' and return
      end
      @notes = @asset.notes
    end
  end

  def export_csv
    @assets = Asset.all
		if params[:start_date].present? && params[:end_date].present?
			start_date = Date.parse(params[:start_date])
			end_date = Date.parse(params[:end_date])
      @assets = @assets.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
		end
		
    csv_data = CSV.generate(headers: true) do |csv|
      # Adding the new column headers
      csv << ['ID', 'Status', 'Created At', 'Updated At', 'Unique ID', 'Name', 'Category', 'Brand', 'Model', 'Specifications', 'Serial Number', 'Purchase Date', 'Warranty Expiry', 'Condition', 'Location']
    
      # Iterate through each asset to populate the CSV data
      @assets.each do |asset|
        # Adding the values from each column
        csv << [
          asset.id,
          asset.status,
          asset.created_at,
          asset.updated_at,
          asset.unique_id,               # unique_id column
          asset.name,                    # name column
          asset.asset_category.name,     # Assuming asset_category is an association, you can call the category name (or other attributes) here
          asset.brand,
          asset.model,
          asset.specifications,
          asset.serial_number,
          asset.purchase_date,
          asset.warranty_expiry,
          asset.condition,
          asset.location
        ]
      end
    end

    send_data csv_data, filename: "assets_#{Date.today}.csv", type: 'text/csv', disposition: 'attachment'
  end


  private

  def set_asset
    @asset = Asset.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(
      :unique_id,
      :name,
      :asset_category_id,
      :brand,
      :model,
      :specifications,
      :serial_number,
      :purchase_date,
      :warranty_expiry,
      :status,
      :condition,
      :location
    )
  end

  def ensure_admin
    redirect_to root_path, alert: 'You must be an admin to perform this action.' unless current_user.admin?
  end
end

