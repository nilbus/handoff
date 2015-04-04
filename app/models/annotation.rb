class Annotation < ActiveRecord::Base
  belongs_to :handoff
  belongs_to :author, class_name: 'User'
end
