module HandoffsHelper
  def annotation_template
    template = Comment.new author: current_user
    {template: [template]}
  end
end
