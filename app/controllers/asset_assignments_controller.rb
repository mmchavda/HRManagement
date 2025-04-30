class AssetAssignmentsController < ApplicationController
	before_action :set_asset, except: [:index, :new, :confirm_unassign, :unassign]

	def index
		@asset = Asset.find(params[:asset_id])
		@assignments = @asset.asset_assignments.order(created_at: :desc)
		@assignments = @assignments.page(params[:page]).per(10)
	end

	def new
		@asset = Asset.find(params[:asset_id] || params[:id])
		#@asset = Asset.find(params[:asset_id])

		@users = User.all
	end

	def confirm_unassign
	
		@asset = Asset.find(params[:asset_id] || params[:id])
    @asset_assignment = @asset.current_assignment
  end

  def unassign
		@asset = Asset.find(params[:asset_id] || params[:id])
		@asset_assignment = @asset.current_assignment
		if @asset_assignment
			@asset_assignment.update!(
			#	user_id: nil,
				active: false,
				returned_at: Time.current,
				comments: params[:comments]
			)
		end
		# Update the asset's status
		new_status = params[:asset_assignment][:status]
		@asset.update!(status: new_status)
		redirect_to @asset, notice: 'Asset has been unassigned and status updated.'
	end
	
  def create
    # Deactivate current assignment (if exists)
    if @asset.current_assignment
      @asset.current_assignment.update!(
        active: false,
        returned_at: Time.current,
        comments: assignment_params[:comments]
      )
    end

    # Create new assignment with assignment timestamp
    @asset.asset_assignments.create!(
      user_id: assignment_params[:user_id],
      assigned_at: Time.current,
      active: true,
      comments: assignment_params[:comments]
    )

    @asset.update!(status: :assigned)

    redirect_to @asset, notice: "Asset assigned successfully."
  end

  def destroy
    if @asset.current_assignment
      @asset.current_assignment.update!(
        active: false,
        returned_at: Time.current,
        comments: assignment_params[:comments]
      )

      @asset.update!(status: params[:new_status] || :available)
    end

    redirect_to @asset, notice: "Asset unassigned and marked as #{@asset.status.humanize}."
  end

  private

  def set_asset
    @asset = Asset.find(params[:asset_id])
  end

  def assignment_params
    params.permit(:user_id, :comments)
  end
end
  