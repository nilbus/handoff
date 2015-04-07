class AnnotationsController < ApplicationController
  def create
    @annotation = Annotation.new(annotation_params)
    @annotation.author = current_user
    @annotation.save!
    if request.xhr?
      render partial: 'handoffs/annotation', object: @annotation
    else
      redirect_to handoff_path(@annotation.handoff)
    end
  end

  def update
  end

  def destroy
  end

  private

  def annotation_params
    params.require(:annotation).permit(:content, :type, :handoff_id, :resource_id)
  end
end
