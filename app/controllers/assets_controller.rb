class AssetsController < ApplicationController
  # app/controllers/assets_controller.rb
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_asset, only: [:show, :edit, :update, :destroy]

  def index
    @assets = Asset.all.includes(:asset_category, :notes) # eager load associations
  end

  def new
    @asset = Asset.new
    @asset_categories = AssetCategory.all
  end

  def create
    @asset = Asset.new(asset_params)
    if @asset.save
      redirect_to assets_path, notice: 'Asset was successfully created.'
    else
      @asset_categories = AssetCategory.all
      render :new
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
    @notes = @asset.notes
  end

  private

  def set_asset
    @asset = Asset.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(:name, :description, :asset_category_id, :status, :deleted_at)
  end

  def ensure_admin
    redirect_to root_path, alert: 'You must be an admin to perform this action.' unless current_user.admin?
  end
end

