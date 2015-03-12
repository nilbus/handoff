class Share < ActiveRecord::Base
  belongs_to :handoff
  belongs_to :user
end
