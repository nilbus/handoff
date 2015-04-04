class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable
  has_many :shares
  has_many :handoffs

  def name
    email # until we have a name
  end
end
