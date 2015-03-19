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
    API.update_patient(self) unless @got_full_name || @fname.present? && @lname.present?
    @got_full_name = true
    "#{@fname} #{@lname}"
  end

  def observations
    return if @got_observations
    API.update_patient_observations(self)
    @got_observations = true
    @observations
  end

  def conditions
    return if @got_conditions
    API.update_patient_conditions(self)
    @got_conditions = true
    @conditions
  end

  def medications
    return if @got_medications
    API.update_patient_medications(self)
    @got_medications = true
    @medications
  end

end
