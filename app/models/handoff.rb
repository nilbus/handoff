class Handoff < ActiveRecord::Base
  has_many :shares
  has_many :annotations
  belongs_to :creator, class_name: 'User'

  def lastModified
    latest = updated_at

    annotations = annotations()

    if annotations.size < 1
      return latest
    end

    annotations.each do |annotation|
      if annotation.updated_at > latest
        latest = annotation.updated_at
      end
    end

    latest
  end
end
