class AnnotationsController < ApplicationController
  def create
    @annotation = Annotation.new(annotation_params)
    @annotation.author = current_user
    @annotation.save!

    share = Share.find_by(handoff_id: @annotation.handoff.id, user_id: current_user.id)
    share.update(last_view: DateTime.now)

    if request.xhr?
      render partial: 'handoffs/annotation', object: @annotation
    else
      redirect_to handoff_path(@annotation.handoff)
    end
  end

  private

  def annotation_params
    params.require(:annotation).permit(:content, :type, :handoff_id, :resource_id)
  end
end
