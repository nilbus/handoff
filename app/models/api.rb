class API
  require "httparty"
  require "json"
  attr_reader :base_url, :rpath_pat, :rpath_obs, :rpath_con, :rpath_med, :rpath_params, :rpath_for_patient_prefix
  @base_url
  @rpath_pat
  @rpath_obs
  @rpath_con
  @rpath_med
  @rpath_params
  @rpath_for_patient_prefix

  def initialize
    #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    @base_url = "https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/"
    @rpath_pat = "Patient/"
    @rpath_obs = "Observation/"
    @rpath_con = "Condition/"
    @rpath_med = "MedicationPrescription/"
    @rpath_params = "?_format=json"
    @rpath_for_patient_prefix = "&subject=Patient/"
  end

### Patients

  def GetPatientObjectFromData(patient_data)
    this_name_first = patient_data["name"][0]["given"]
    this_name_last = patient_data["name"][0]["family"]
    this_pid = patient_data["identifier"][0]["value"]      
    Patient.new(this_name_first, this_name_last, this_pid)
  end

  def GetPatientList()
    thisURL = "#{@base_url}#{@rpath_pat}#{@rpath_params}"
    puts thisURL
    results = HTTParty.get("#{@base_url}#{@rpath_pat}#{@rpath_params}")
    resultsHash = JSON.parse(results.body)
    patients = resultsHash["entry"].map do |patient_data|
      GetPatientObjectFromData(patient_data["content"])
    end
  end
  
  def GetPatientFromPID(pid)
    results = HTTParty.get("#{@base_url}#{@rpath_pat}#{pid}#{@rpath_params}")
    resultsHash = JSON.parse(results.body)
    GetPatientObjectFromData(resultsHash)
  end

### Observations

  def PatientObservations(patient)
    results = HTTParty.get("#{@base_url}#{@rpath_obs}#{@rpath_params}#{@rpath_for_patient_prefix}#{@patient.pid}")
  end
end
