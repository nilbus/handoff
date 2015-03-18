class API
  BASE_URL_CONST = "https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/"
  RPATH_PAT_CONST = "Patient/"
  RPATH_OBS_CONST = "Observation/"
  RPATH_CON_CONST = "Condition/"
  RPATH_MED_CONST = "MedicationPrescription/"
  RPATH_PARAMS_CONST = "?_format=json"
  RPATH_FOR_PATIENT_PREFIX_CONST = "&subject=Patient/"

### Patients

  def self.get_patient_object_from_data(patient_data)
  # pid, fname = nil, lname = nil
    this_pid = patient_data["identifier"][0]["value"] if dig(patient_data, "identifier", "array", "value")
    this_name_first = patient_data["name"][0]["given"].first if dig(patient_data,"name", "array", "given")
    this_name_last = patient_data["name"][0]["family"].first if dig(patient_data, "name", "array", "family")
    Patient.new(this_pid, this_name_first, this_name_last)
  end

  def self.all_patients()
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{RPATH_PARAMS_CONST}")
    resultsHash = JSON.parse(results.body)
    patients = resultsHash["entry"].map do |patient_data|
      get_patient_object_from_data(patient_data["content"])
    end
  end

  def self.update_patient(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{patient.pid}#{RPATH_PARAMS_CONST}")
    resultsHash = JSON.parse(results.body)
    patient.fname = resultsHash["name"][0]["given"].first
    patient.lname = resultsHash["name"][0]["family"].first
    patient
  end

  def self.get_patient_from_pid(pid)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{pid}#{RPATH_PARAMS_CONST}")
    resultsHash = JSON.parse(results.body)
    get_patient_object_from_data(resultsHash)
  end

### Observations

  def self.get_observation_object_from_data(observation_data)
    # id, value, units, comment, pub_date, status, reliability, code_system, code, display_div
    this_id = observation_data["id"] if self.dig(observation_data, "id")
    this_value = observation_data["content"]["valueQuantity"]["value"] if dig(observation_data, "content", "valueQuantity", "value")
    this_units = observation_data["content"]["valueQuantity"]["units"] if dig(observation_data, "content", "valueQuantity", "units")
    this_comment = observation_data["content"]["comments"] if dig(observation_data, "content", "comments")
    this_pub_date = observation_data["published"] if dig(observation_data, "published")
    this_status = observation_data["content"]["status"] if dig(observation_data, "content", "status")
    this_reliability = observation_data["content"]["reliability"] if dig(observation_data, "content", "reliability")
    this_code_system = observation_data["content"]["name"]["coding"][0]["system"] if dig(observation_data, "content", "name", "coding", "array", "system")
    this_code = observation_data["content"]["name"]["coding"][0]["code"] if dig(observation_data, "content", "name", "coding", "array", "code")
    this_display = observation_data["content"]["text"]["div"] if dig(observation_data, "content", "text", "div")
    Observation.new(this_display, this_id, this_value, this_units, this_comment, this_pub_date, this_status, this_reliability, this_code_system, this_code)
  end

  def self.update_patient_observations(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_OBS_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}")
    resultsHash = JSON.parse(results.body)
    patient.observations = resultsHash["entry"].map do |observation_data|
      get_observation_object_from_data(observation_data)
    end
  end

### Conditions

  def self.get_condition_object_from_data(condition_data)
    #id, value, onset_date, status, code_system, code
    this_id = condition_data["id"] if dig(condition_data, "id")
    this_value = condition_data["content"]["code"]["coding"][0]["display"] if dig(condition_data, "content", "code", "coding", "array", "display")
    this_onset_date = condition_data["content"]["onsetDate"] if dig(condition_data, "content", "onsetDate")
    this_status = condition_data["content"]["status"] if dig(condition_data, "content", "status")
    this_code_system = condition_data["content"]["code"]["coding"][0]["system"] if dig(condition_data, "content", "code", "coding", "array", "system")
    this_code = condition_data["content"]["code"]["coding"][0]["code"] if dig(condition_data, "content", "code", "coding", "array", "code")
    Condition.new(this_id, this_value, this_onset_date, this_status, this_code_system, this_code)
  end

  def self.update_patient_conditions(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_CON_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}")
    resultsHash = JSON.parse(results.body)
    patient.conditions = resultsHash["entry"].map do |condition_data|
      get_condition_object_from_data(condition_data)
    end
  end

### Medications

  def self.get_medication_object_from_data(medication_data)
    #id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code
    this_id = medication_data["id"] if dig(medication_data, "id")
    this_value = medication_data["content"]["medication"]["display"] if dig(medication_data, "content", "medication", "display")
    this_status = medication_data["content"]["status"] if dig(medication_data, "content", "status")
    this_prescriber = medication_data["content"]["prescriber"]["display"] if dig(medication_data, "content", "prescriber", "display")
    this_written_date = medication_data["content"]["dateWritten"] if dig(medication_data, "content", "dateWritten")
    this_dosage_value = medication_data["content"]["dosageInstruction"][0]["doseQuantity"]["value"] if dig(medication_data, "content", "dosageInstruction", "array", "doseQuantity", "value")
    this_dosage_units = medication_data["content"]["dosageInstruction"][0]["doseQuantity"]["units"] if dig(medication_data, "content", "dosageInstruction", "array", "doseQuantity", "units")
    this_dosage_text = medication_data["content"]["dosageInstruction"][0]["text"] if dig(medication_data, "content", "dosageInstruction", "array", "text")
    this_dispense_quantity = medication_data["content"]["dispense"]["quantity"]["value"] if dig(medication_data, "content", "dispense", "quantity", "value")
    this_dispense_repeats = medication_data["content"]["dispense"]["numberOfRepeatsAllowed"] if dig(medication_data,"content", "dispense", "numberOfRepeatsAllowed")
    this_coding_system = medication_data["content"]["contained"][0]["code"]["coding"][0]["system"] if dig(medication_data, "content", "contained", "array", "code", "coding", "array", "system")
    this_code = medication_data["content"]["contained"][0]["code"]["coding"][0]["code"] if dig(medication_data, "content", "contained", "array", "code", "coding", "array", "code")
    Medication.new(this_id, this_value, this_status, this_prescriber, this_written_date, this_dosage_value, this_dosage_units, this_dosage_text, this_dispense_quantity, this_dispense_repeats, this_coding_system, this_code)
  end

  def self.update_patient_medications(patient)
    results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_MED_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}")
    resultsHash = JSON.parse(results.body)
    patient.medications = resultsHash["entry"].map do |medication_data|
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

  # http://stackoverflow.com/questions/1820451/ruby-style-how-to-check-whether-a-nested-hash-element-exists
  #class Hash
    #def dig(*path)
      #path.inject(self) do |location, key|
        #location.respond_to?(:keys) ? location[key] : nil
      #end
    #end
  #end

end
