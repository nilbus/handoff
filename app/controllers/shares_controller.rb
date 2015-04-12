class SharesController < ApplicationController
  def new
  end

  def create
    @share = Share.new(share_params)
    @share.save()
    @handoff = Handoff.find(share_params['handoff_id'])
    redirect_to @handoff
  end

  def destroy
  end

  def share_params
    # TODO we don't actually ensure that the person creating the share has access to the handoff!
    params.require(:share).permit(:handoff_id, :user_id)
  end
end
