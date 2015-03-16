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
  # pid, fname = nil, lname = nil
    this_pid = patient_data["identifier"][0]["value"] #if dig(patient_data, :identifier, :value)
    this_name_first = patient_data["name"][0]["given"] #if dig(patient_data,:name, :given)
    this_name_last = patient_data["name"][0]["family"] #if dig(patient_data, :name, :family)
    Patient.new(this_pid, this_name_first, this_name_last)
  end

  def GetPatientList()
    results = HTTParty.get("#{@base_url}#{@rpath_pat}#{@rpath_params}")
    resultsHash = JSON.parse(results.body)
    patients = resultsHash["entry"].map do |patient_data|
      GetPatientObjectFromData(patient_data["content"])
    end
  end
  
  def UpdatePatient(patient)
    results = HTTParty.get("#{@base_url}#{@rpath_pat}#{patient.pid}#{@rpath_params}")
    resultsHash = JSON.parse(results.body)
    patient.fname = resultsHash["name"][0]["given"]
    patient.lname = resultsHash["name"][0]["family"]
    patient
  end
  
  def GetPatientFromPID(pid)
    results = HTTParty.get("#{@base_url}#{@rpath_pat}#{pid}#{@rpath_params}")
    resultsHash = JSON.parse(results.body)
    GetPatientObjectFromData(resultsHash)
  end

### Observations

  def GetObservationObjectFromData(observation_data)
    # id, value, units, comment, pub_date, status, reliability, code_system, code
    this_id = observation_data["id"] #if dig(observation_data, :id)
    this_value = observation_data["content"]["valueQuantity"]["value"] if dig(observation_data, :content, :valueQuantity, :value)
    this_units = observation_data["content"]["valueQuantity"]["units"] if dig(observation_data, :content, :valueQuantity, :units)
    this_comment = observation_data["content"]["comments"] #if dig(observation_data, :content, :comments)
    this_pub_date = observation_data["published"] #if dig(observation_data, :published)
    this_status = observation_data["content"]["status"] #if dig(observation_data, :content, :status)
    this_reliability = observation_data["content"]["reliability"] #if dig(observation_data, :content, :reliability)
    this_code_system = observation_data["content"]["name"]["coding"][0]["system"] #if dig(observation_data, :content, :name, :coding, :system)
    this_code = observation_data["content"]["name"]["coding"][0]["code"] #if dig(observation_data, :content, :name, :coding, :code)
    Observation.new(this_id, this_value, this_units, this_comment, this_pub_date, this_status, this_reliability, this_code_system, this_code)
  end

  def UpdatePatientObservations(patient)
    results = HTTParty.get("#{@base_url}#{@rpath_obs}#{@rpath_params}#{@rpath_for_patient_prefix}#{patient.pid}")
    resultsHash = JSON.parse(results.body)
    patient.observations = resultsHash["entry"].map do |observation_data|
      GetObservationObjectFromData(observation_data)
    end
  end
  
### Conditions

  def GetConditionObjectFromData(condition_data)
    #id, value, onset_date, status, code_system, code
    this_id = condition_data["id"] #if dig(condition_data, :id)
    this_value = condition_data["content"]["code"]["coding"][0]["display"] #if dig(condition_data, :content, :code, :coding, :display)
    this_onset_date = condition_data["content"]["onsetDate"] #if dig(condition_data, :content, :onsetDate)
    this_status = condition_data["content"]["status"] #if dig(condition_data, :content, :status)
    this_code_system = condition_data["content"]["code"]["coding"][0]["system"] #if dig(condition_data, :content, :code, :coding, :system)
    this_code = condition_data["content"]["code"]["coding"][0]["code"] #if dig(condition_data, :content, :code, :coding, :code)
    Condition.new(this_id, this_value, this_onset_date, this_status, this_code_system, this_code)
  end

  def UpdatePatientConditions(patient)
    results = HTTParty.get("#{@base_url}#{@rpath_con}#{@rpath_params}#{@rpath_for_patient_prefix}#{patient.pid}")
    resultsHash = JSON.parse(results.body)
    patient.conditions = resultsHash["entry"].map do |condition_data|
      GetConditionObjectFromData(condition_data)
    end
  end

### Medications

  def GetMedicationObjectFromData(medication_data)
    #id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code
    this_id = medication_data["id"] #if dig(medication_data, :id)
    this_value = medication_data["content"]["medication"]["display"] #if dig(medication_data, :content, :medication, :display)
    this_status = medication_data["content"]["status"] #if dig(medication_data, :content, :status)
    this_prescriber = medication_data["content"]["prescriber"]["display"] #if dig(medication_data, :content, :prescriber, :display)
    this_written_date = medication_data["content"]["dateWritten"] #if dig(medication_data, :content, :dateWritten)
    this_dosage_value = medication_data["content"]["dosageInstruction"][0]["doseQuantity"]["value"] #if dig(medication_data, :content, :dosageInstruction, :doseQuantity, :value)
    this_dosage_units = medication_data["content"]["dosageInstruction"][0]["doseQuantity"]["units"] #if dig(medication_data, :content, :dosageInstruction, :doseQuantity, :units)
    this_dosage_text = medication_data["content"]["dosageInstruction"][0]["text"] #if dig(medication_data, :content, :dosageInstruction, :text)
    this_dispense_quantity = medication_data["content"]["dispense"]["quantity"]["value"] #if dig(medication_data,:content, :dispense, :quantity, :value)
    this_dispense_repeats = medication_data["content"]["dispense"]["numberOfRepeatsAllowed"] #if dig(medication_data,:content, :dispense, :numberOfRepeatsAllowed)
    this_coding_system = medication_data["content"]["contained"][0]["code"]["coding"][0]["system"] #if dig(medication_data, :content, :contained, :code, :coding, :system)
    this_code = medication_data["content"]["contained"][0]["code"]["coding"][0]["code"] #if dig(medication_data, :content, :contained, :code, :coding, :code)
    Medication.new(this_id, this_value, this_status, this_prescriber, this_written_date, this_dosage_value, this_dosage_units, this_dosage_text, this_dispense_quantity, this_dispense_repeats, this_coding_system, this_code)
  end

  def UpdatePatientMedications(patient)
    results = HTTParty.get("#{@base_url}#{@rpath_med}#{@rpath_params}#{@rpath_for_patient_prefix}#{patient.pid}")
    resultsHash = JSON.parse(results.body)
    patient.medications = resultsHash["entry"].map do |medication_data|
      GetMedicationObjectFromData(medication_data)
    end
  end
  
  def dig(hash, *path)
    path.inject(hash) do |location, key|
      location.respond_to?(:keys) ? location[key] : nil
    end
  end
  
end
