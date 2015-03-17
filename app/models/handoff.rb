class Handoff < ActiveRecord::Base
  has_many :shares
  has_many :annotations
  belongs_to :creator, class_name: 'User'
end
