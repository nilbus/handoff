class Patient
  attr_accessor :fname, :lname, :pid, :observations, :conditions, :medications, :fhir

  class << self
    def all
      API.all_patients
    end
  end

  def initialize(pid, fname = nil, lname = nil)
    @pid = pid
    @fname = fname
    @lname = lname
  end

  def full_name
    "#{@fname} #{@lname}"
  end

  def get_data
    API.update_patient(self)
    API.update_patient_observations(self)
    API.update_patient_conditions(self)
    API.update_patient_medications(self)
    self
  end

end
