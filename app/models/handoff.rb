class Handoff < ActiveRecord::Base
  has_many :shares
  has_many :annotations
end
