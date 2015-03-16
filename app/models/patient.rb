class Patient
  attr_accessor :fname, :lname, :pid, :observations, :conditions, :medications, :fhir
  @fname
  @lname
  @pid
  @observations
  @conditions
  @medications
  @fhir

  def initialize(pid, fname = nil, lname = nil)
    @pid = pid
    @fname = fname
    @lname = lname
    @fhir = API.new
  end

  def FullName
    '#{@fname} #{@lname}'
  end

  def GetData()
    @fhir.UpdatePatient(self)
    @fhir.UpdatePatientObservations(self)
    @fhir.UpdatePatientConditions(self)
    @fhir.UpdatePatientMedications(self)
    self
  end

end
