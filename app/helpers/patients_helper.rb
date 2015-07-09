module PatientsHelper
  def self.grouped_and_sorted(assessments)
    assessments.sort_by!(&:date).group_by(&:key)
  end
end
