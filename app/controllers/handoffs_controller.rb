class HandoffsController < ApplicationController
  def index
    @handoffs = Handoff.joins('JOIN shares ON handoffs.id = shares.handoff_id').where("shares.user_id = #{current_user.id}")
  end

  def show
    @handoff = Handoff.find(params[:id])
    @annotations_by_resource = @handoff.annotations.sequential.group_by(&:resource_id)
    @patient_data = Patient.new(@handoff.patient_id)
    raise ActiveRecord::RecordNotFound, 'You do not have access to this handoff' unless @handoff.shares.map(&:user_id).include?(current_user.id)
    share = Share.find_by(handoff_id: @handoff.id, user_id: current_user.id)
    share.update(last_view: DateTime.now())
  end

  def create
    @handoff = Handoff.new(handoff_params)
    @handoff.shares.build(:user_id => @handoff.creator_id, :last_view => DateTime.now)
    @handoff.save()
    redirect_to @handoff
  end

  def destroy
  end

  def handoff_params
    params.require(:handoff).permit(:creator_id, :patient_id, :name, :description)
  end
end
