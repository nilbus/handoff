class API
  BASE_URL_CONST = "https://healthport.i3l.gatech.edu:8443/dstu1/fhir/"
  RPATH_PAT_CONST = "Patient/"
  RPATH_OBS_CONST = "Observation/"
  RPATH_CON_CONST = "Condition/"
  RPATH_MED_CONST = "MedicationPrescription/"
  RPATH_PARAMS_CONST = "?_format=json"
  RPATH_FOR_PATIENT_PREFIX_CONST = "&subject=Patient/"
  RPATH_COUNT_100_CONST = "&_count=100"

### Patients

  def self.get_patient_object_from_data(patient_data)
    this_pid        = dig_with_specified_array_location(patient_data, 0, "identifier", "array", "value")
    this_name_first = dig_with_specified_array_location(patient_data, 0, "name", "array", "given", "array")
    this_name_last  = dig_with_specified_array_location(patient_data, 0, "name", "array", "family", "array")
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
    this_id          = dig_with_specified_array_location(observation_data, 0, "id")
    this_value       = dig_with_specified_array_location(observation_data, 0, "content", "valueQuantity", "value")
    this_units       = dig_with_specified_array_location(observation_data, 0, "content", "valueQuantity", "units")
    this_comment     = dig_with_specified_array_location(observation_data, 0, "content", "comments")
    this_date        = dig_with_specified_array_location(observation_data, 0, "con tent", "appliesDateTime")
    this_status      = dig_with_specified_array_location(observation_data, 0, "content", "status")
    this_reliability = dig_with_specified_array_location(observation_data, 0, "content", "reliability")
    this_code_system = dig_with_specified_array_location(observation_data, 0, "content", "name", "coding", "array", "system")
    this_code        = dig_with_specified_array_location(observation_data, 0, "content", "name", "coding", "array", "code")
    this_code_text   = dig_with_specified_array_location(observation_data, 0, "content", "name", "coding", "array", "display")
    this_display     = dig_with_specified_array_location(observation_data, 0, "content", "text", "div")
    Observation.new(this_display, this_id, this_value, this_units, this_comment, this_date, this_status, this_reliability, this_code_system, this_code, this_code_text)
  end

  def self.update_patient_observations(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_OBS_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}#{RPATH_COUNT_100_CONST}")
    results_hash = JSON.parse(results.body)
    observation_array = results_hash["entry"].map do |observation_data|
      get_observation_object_from_data(observation_data)
    end

    data_collection_done = false
    while data_collection_done == false do
      results_next_tag = dig_with_specified_array_location(results_hash, 1, "link", "array", "rel")
      results_next_url = dig_with_specified_array_location(results_hash, 1, "link", "array", "href")
      if not results_next_tag == "next"
        results_next_tag = dig_with_specified_array_location(results_hash, 2, "link", "array", "rel")
        results_next_url = dig_with_specified_array_location(results_hash, 2, "link", "array", "href")
      end
      if results_next_tag == "next"
        results = nil
        more_observations = nil
        results = HTTParty.get(results_next_url)
        results_hash = JSON.parse(results.body)
        more_observations = results_hash["entry"].map do |observation_data|
          get_observation_object_from_data(observation_data)
        end
        observation_array = observation_array + more_observations
      else
        data_collection_done = true
      end
    end
    patient.observations = observation_array
  end

### Conditions

  def self.get_condition_object_from_data(condition_data)
    #id, value, onset_date, status, code_system, code
    this_id          = dig_with_specified_array_location(condition_data, 0, "id")
    this_value       = dig_with_specified_array_location(condition_data, 0, "content", "code", "coding", "array", "display")
    this_onset_date  = dig_with_specified_array_location(condition_data, 0, "content", "onsetDate")
    this_status      = dig_with_specified_array_location(condition_data, 0, "content", "status")
    this_code_system = dig_with_specified_array_location(condition_data, 0, "content", "code", "coding", "array", "system")
    this_code        = dig_with_specified_array_location(condition_data, 0, "content", "code", "coding", "array", "code")
    Condition.new(this_id, this_value, this_onset_date, this_status, this_code_system, this_code)
  end

  def self.update_patient_conditions(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_CON_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}#{RPATH_COUNT_100_CONST}")
    results_hash = JSON.parse(results.body)
    condition_array = results_hash["entry"].map do |condition_data|
      get_condition_object_from_data(condition_data)
    end

    data_collection_done = false
    while data_collection_done == false do
      results_next_tag = dig_with_specified_array_location(results_hash, 1, "link", "array", "rel")
      results_next_url = dig_with_specified_array_location(results_hash, 1, "link", "array", "href")
      if not results_next_tag == "next"
        results_next_tag = dig_with_specified_array_location(results_hash, 2, "link", "array", "rel")
        results_next_url = dig_with_specified_array_location(results_hash, 2, "link", "array", "href")
      end
      if results_next_tag == "next"
        results = nil
        more_conditions = nil
        results = HTTParty.get(results_next_url)
        results_hash = JSON.parse(results.body)
        more_conditions = results_hash["entry"].map do |condition_data|
          get_condition_object_from_data(condition_data)
        end
        condition_array = condition_array + more_conditions
      else
        data_collection_done = true
      end
    end
    patient.conditions = condition_array
  end

### Medications

  def self.get_medication_object_from_data(medication_data)
    #id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code
    this_id                = dig_with_specified_array_location(medication_data, 0, "id")
    this_value             = dig_with_specified_array_location(medication_data, 0, "content", "medication", "display")
    this_status            = dig_with_specified_array_location(medication_data, 0, "content", "status")
    this_prescriber        = dig_with_specified_array_location(medication_data, 0, "content", "prescriber", "display")
    this_written_date      = dig_with_specified_array_location(medication_data, 0, "content", "dateWritten")
    this_dosage_value      = dig_with_specified_array_location(medication_data, 0, "content", "dosageInstruction", "array", "doseQuantity", "value")
    this_dosage_units      = dig_with_specified_array_location(medication_data, 0, "content", "dosageInstruction", "array", "doseQuantity", "units")
    this_dosage_text       = dig_with_specified_array_location(medication_data, 0, "content", "dosageInstruction", "array", "text")
    this_dispense_quantity = dig_with_specified_array_location(medication_data, 0, "content", "dispense", "quantity", "value")
    this_dispense_repeats  = dig_with_specified_array_location(medication_data, 0, "content", "dispense", "numberOfRepeatsAllowed")
    this_coding_system     = dig_with_specified_array_location(medication_data, 0, "content", "contained", "array", "code", "coding", "array", "system")
    this_code              = dig_with_specified_array_location(medication_data, 0, "content", "contained", "array", "code", "coding", "array", "code")
    Medication.new(this_id, this_value, this_status, this_prescriber, this_written_date, this_dosage_value, this_dosage_units, this_dosage_text, this_dispense_quantity, this_dispense_repeats, this_coding_system, this_code)
  end

  def self.update_patient_medications(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_MED_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}#{RPATH_COUNT_100_CONST}")
    results_hash = JSON.parse(results.body)
    medication_array = results_hash["entry"].map do |medication_data|
      get_medication_object_from_data(medication_data)
    end

    data_collection_done = false
    while data_collection_done == false do
      results_next_tag = dig_with_specified_array_location(results_hash, 1, "link", "array", "rel")
      results_next_url = dig_with_specified_array_location(results_hash, 1, "link", "array", "href")
      if not results_next_tag == "next"
        results_next_tag = dig_with_specified_array_location(results_hash, 2, "link", "array", "rel")
        results_next_url = dig_with_specified_array_location(results_hash, 2, "link", "array", "href")
      end
      if results_next_tag == "next"
        results = nil
        more_medications = nil
        results = HTTParty.get(results_next_url)
        results_hash = JSON.parse(results.body)
        more_medications = results_hash["entry"].map do |medication_data|
          get_medication_object_from_data(medication_data)
        end
        medication_array = medication_array + more_medications
      else
        data_collection_done = true
      end
    end
    patient.medications = medication_array
  end

### Helper Methods

  def self.dig_with_specified_array_location(hash, array_location, *path)
    path.inject(hash) do |location, key|
      retVal = nil
      if location && location.kind_of?(Hash)
        location[key]
      elsif location && location.kind_of?(Array) && location.length > 0
        location[array_location]
      else
        nil
      end
    end
  end

end
