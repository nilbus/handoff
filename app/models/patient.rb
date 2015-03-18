class Patient
  attr_accessor :fname, :lname, :pid, :fhir
  attr_writer :observations, :conditions, :medications

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

  def observations
    load_data
    @observations
  end

  def conditions
    load_data
    @conditions
  end

  def medications
    load_data
    @medications
  end

  private

  def load_data
    return if @got_data
    API.update_patient(self)
    API.update_patient_observations(self)
    API.update_patient_conditions(self)
    API.update_patient_medications(self)
    @got_data = true
  end

end
