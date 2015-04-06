class AnnotationsController < ApplicationController
  def create
    @annotation = Annotation.new(annotation_params)
    @annotation.author = current_user
    @annotation.save!
    respond_to do |format|
      format.html { redirect_to handoff_path(@annotation.handoff) }
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
