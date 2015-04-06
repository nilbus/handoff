class Annotation < ActiveRecord::Base
  belongs_to :handoff
  belongs_to :author, class_name: 'User'

  scope :sequential, ->{ order(:id) }

  def author_name
    author.name
  end
end
