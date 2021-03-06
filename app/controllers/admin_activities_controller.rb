class AdminActivitiesController < ApplicationController

  # GET /admin_activities
  def index
    @admin_activities = AdminActivity.all 
    
    render json: @admin_activities.as_json(include: {admin: {only: :f_name}, event: {only: :title}}), status: :ok
  end

  # POST /admin_activities
  def create
    @admin_activity = AdminActivity.new(admin_activity_params)

    if @admin_activity.save
      @admin_activities = AdminActivity.all
      render json: @admin_activities, status: :created
    else
      render json: @admin_activity.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def admin_activity_params
    params.require(:admin_activity).permit(:admin_id, :event_id, :action)
  end
end
