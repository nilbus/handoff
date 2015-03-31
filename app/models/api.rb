class API
  BASE_URL_CONST = "https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/"
  RPATH_PAT_CONST = "Patient/"
  RPATH_OBS_CONST = "Observation/"
  RPATH_CON_CONST = "Condition/"
  RPATH_MED_CONST = "MedicationPrescription/"
  RPATH_PARAMS_CONST = "?_format=json"
  RPATH_FOR_PATIENT_PREFIX_CONST = "&subject=Patient/"
  RPATH_COUNT_100_CONST = "&_count=100"

### Patients

  def self.get_patient_object_from_data(patient_data)
    this_pid        = dig(patient_data, "identifier", "array", "value")
    this_name_first = dig(patient_data, "name", "array", "given", "array")
    this_name_last  = dig(patient_data, "name", "array", "family", "array")
    Patient.new(this_pid, this_name_first, this_name_last)
  end

  def self.all_patients()
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{RPATH_PARAMS_CONST}#{RPATH_COUNT_100_CONST}")
    results_hash = JSON.parse(results.body)
    patients = results_hash["entry"].map do |patient_data|
      get_patient_object_from_data(patient_data["content"])
    end
  end

  def self.update_patient(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{patient.pid}#{RPATH_PARAMS_CONST}")
    results_hash = JSON.parse(results.body)
    patient.fname = results_hash["name"][0]["given"].first
    patient.lname = results_hash["name"][0]["family"].first
    patient
  end

  def self.get_patient_from_pid(pid)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{pid}#{RPATH_PARAMS_CONST}")
    results_hash = JSON.parse(results.body)
    get_patient_object_from_data(results_hash)
  end

### Observations

  def self.get_observation_object_from_data(observation_data)
    # id, value, units, comment, pub_date, status, reliability, code_system, code, display_div
    this_id          = dig(observation_data, "id")
    this_value       = dig(observation_data, "content", "valueQuantity", "value")
    this_units       = dig(observation_data, "content", "valueQuantity", "units")
    this_comment     = dig(observation_data, "content", "comments")
    this_date        = dig(observation_data, "content", "appliesDateTime")
    this_status      = dig(observation_data, "content", "status")
    this_reliability = dig(observation_data, "content", "reliability")
    this_code_system = dig(observation_data, "content", "name", "coding", "array", "system")
    this_code        = dig(observation_data, "content", "name", "coding", "array", "code")
    this_code_text   = dig(observation_data, "content", "name", "coding", "array", "display")
    this_display     = dig(observation_data, "content", "text", "div")
    Observation.new(this_display, this_id, this_value, this_units, this_comment, this_date, this_status, this_reliability, this_code_system, this_code, this_code_text)
  end

  def self.update_patient_observations(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_OBS_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}")
    results_hash = JSON.parse(results.body)
    patient.observations = results_hash["entry"].map do |observation_data|
      get_observation_object_from_data(observation_data)
    end
  end

### Conditions

  def self.get_condition_object_from_data(condition_data)
    #id, value, onset_date, status, code_system, code
    this_id          = dig(condition_data, "id")
    this_value       = dig(condition_data, "content", "code", "coding", "array", "display")
    this_onset_date  = dig(condition_data, "content", "onsetDate")
    this_status      = dig(condition_data, "content", "status")
    this_code_system = dig(condition_data, "content", "code", "coding", "array", "system")
    this_code        = dig(condition_data, "content", "code", "coding", "array", "code")
    Condition.new(this_id, this_value, this_onset_date, this_status, this_code_system, this_code)
  end

  def self.update_patient_conditions(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_CON_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}")
    results_hash = JSON.parse(results.body)
    patient.conditions = results_hash["entry"].map do |condition_data|
      get_condition_object_from_data(condition_data)
    end
  end

### Medications

  def self.get_medication_object_from_data(medication_data)
    #id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code
    this_id                = dig(medication_data, "id")
    this_value             = dig(medication_data, "content", "medication", "display")
    this_status            = dig(medication_data, "content", "status")
    this_prescriber        = dig(medication_data, "content", "prescriber", "display")
    this_written_date      = dig(medication_data, "content", "dateWritten")
    this_dosage_value      = dig(medication_data, "content", "dosageInstruction", "array", "doseQuantity", "value")
    this_dosage_units      = dig(medication_data, "content", "dosageInstruction", "array", "doseQuantity", "units")
    this_dosage_text       = dig(medication_data, "content", "dosageInstruction", "array", "text")
    this_dispense_quantity = dig(medication_data, "content", "dispense", "quantity", "value")
    this_dispense_repeats  = dig(medication_data, "content", "dispense", "numberOfRepeatsAllowed")
    this_coding_system     = dig(medication_data, "content", "contained", "array", "code", "coding", "array", "system")
    this_code              = dig(medication_data, "content", "contained", "array", "code", "coding", "array", "code")
    Medication.new(this_id, this_value, this_status, this_prescriber, this_written_date, this_dosage_value, this_dosage_units, this_dosage_text, this_dispense_quantity, this_dispense_repeats, this_coding_system, this_code)
  end

  def self.update_patient_medications(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_MED_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}")
    results_hash = JSON.parse(results.body)
    patient.medications = results_hash["entry"].map do |medication_data|
      get_medication_object_from_data(medication_data)
    end
  end

### Helper Methods

  def self.dig(hash, *path)
    path.inject(hash) do |location, key|
      retVal = nil
      if location && location.kind_of?(Hash)
        location[key]
      elsif location && location.kind_of?(Array) && location.length > 0
        location.first
      else
        nil
      end
    end
  end

end
