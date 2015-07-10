class API
  BASE_URL_CONST = "https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/"
  RPATH_PARAMS_CONST = "?_format=json"
  RPATH_FOR_PATIENT_PREFIX_CONST = "&subject=Patient/"
  RPATH_COUNT_100_CONST = "&_count=100"

  def self.dig_with_specified_array_location(hash, array_location, *path)
    path.inject(hash) do |location, key|
      if location && location.kind_of?(Hash)
        location[key]
      elsif location && location.kind_of?(Array) && location.length > 0
        location[array_location]
      else
        nil
      end
    end
  end

  def all_patients
    Patient.new.all
  end

  def update_patient(patient)
    Patient.new.update(patient)
  end

  def update_patient_assessments(type, patient)
    patient.send "#{type}=", type_class.new(patient).fetch_assessments
  end

  private

  def type_class(type)
    self.class.const_get(type.to_s.classify)
  end

  class Assessment
    attr_accessor :patient

    def initialize(patient)
      @patient = patient
    end

    def fetch_assessments
      response = HTTParty.get(url)
      results = JSON.parse(response.body)
      assessments = results["entry"].map do |assessment|
        extract_object_from_data(assessment)
      end

      loop do
        results_next_tag = API.dig_with_specified_array_location(results, 1, "link", "array", "rel")
        results_next_url = API.dig_with_specified_array_location(results, 1, "link", "array", "href")
        unless results_next_tag == "next"
          results_next_tag = API.dig_with_specified_array_location(results, 2, "link", "array", "rel")
          results_next_url = API.dig_with_specified_array_location(results, 2, "link", "array", "href")
        end
        break unless results_next_tag == "next"
        response = HTTParty.get(results_next_url)
        results = JSON.parse(response.body)
        assessments += results["entry"].map do |assessment|
          extract_object_from_data(assessment)
        end
      end
      assessments
    end
  end

  class Observation < Assessment
    RPATH_CONST = "Observation/"

    def extract_object_from_data(observation_data)
      # id, value, units, comment, pub_date, status, reliability, code_system, code, display_div
      this_id          = API.dig_with_specified_array_location(observation_data, 0, "id")
      this_value       = API.dig_with_specified_array_location(observation_data, 0, "content", "valueQuantity", "value")
      this_units       = API.dig_with_specified_array_location(observation_data, 0, "content", "valueQuantity", "units")
      this_comment     = API.dig_with_specified_array_location(observation_data, 0, "content", "comments")
      this_date        = API.dig_with_specified_array_location(observation_data, 0, "con tent", "appliesDateTime")
      this_status      = API.dig_with_specified_array_location(observation_data, 0, "content", "status")
      this_reliability = API.dig_with_specified_array_location(observation_data, 0, "content", "reliability")
      this_code_system = API.dig_with_specified_array_location(observation_data, 0, "content", "name", "coding", "array", "system")
      this_code        = API.dig_with_specified_array_location(observation_data, 0, "content", "name", "coding", "array", "code")
      this_code_text   = API.dig_with_specified_array_location(observation_data, 0, "content", "name", "coding", "array", "display")
      this_display     = API.dig_with_specified_array_location(observation_data, 0, "content", "text", "div")
      Observation.new(this_display, this_id, this_value, this_units, this_comment, this_date, this_status, this_reliability, this_code_system, this_code, this_code_text)
    end

    def url
      "#{BASE_URL_CONST}#{RPATH_OBS_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}#{RPATH_COUNT_100_CONST}"
    end
  end

  class Condition < Assessment
    RPATH_CONST = "Condition/"

    def extract_object_from_data(condition_data)
      #id, value, onset_date, status, code_system, code
      this_id          = API.dig_with_specified_array_location(condition_data, 0, "id")
      this_value       = API.dig_with_specified_array_location(condition_data, 0, "content", "code", "coding", "array", "display")
      this_onset_date  = API.dig_with_specified_array_location(condition_data, 0, "content", "onsetDate")
      this_status      = API.dig_with_specified_array_location(condition_data, 0, "content", "status")
      this_code_system = API.dig_with_specified_array_location(condition_data, 0, "content", "code", "coding", "array", "system")
      this_code        = API.dig_with_specified_array_location(condition_data, 0, "content", "code", "coding", "array", "code")
      Condition.new(this_id, this_value, this_onset_date, this_status, this_code_system, this_code)
    end

    def url(patient_pidd)
      "#{BASE_URL_CONST}#{RPATH_CON_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient_pid}#{RPATH_COUNT_100_CONST}"
    end
  end

  class Medication < Assessment
    RPATH_CONST = "MedicationPrescription/"

    def extract_object_from_data(medication_data)
      #id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code
      this_id                = API.dig_with_specified_array_location(medication_data, 0, "id")
      this_value             = API.dig_with_specified_array_location(medication_data, 0, "content", "medication", "display")
      this_status            = API.dig_with_specified_array_location(medication_data, 0, "content", "status")
      this_prescriber        = API.dig_with_specified_array_location(medication_data, 0, "content", "prescriber", "display")
      this_written_date      = API.dig_with_specified_array_location(medication_data, 0, "content", "dateWritten")
      this_dosage_value      = API.dig_with_specified_array_location(medication_data, 0, "content", "dosageInstruction", "array", "doseQuantity", "value")
      this_dosage_units      = API.dig_with_specified_array_location(medication_data, 0, "content", "dosageInstruction", "array", "doseQuantity", "units")
      this_dosage_text       = API.dig_with_specified_array_location(medication_data, 0, "content", "dosageInstruction", "array", "text")
      this_dispense_quantity = API.dig_with_specified_array_location(medication_data, 0, "content", "dispense", "quantity", "value")
      this_dispense_repeats  = API.dig_with_specified_array_location(medication_data, 0, "content", "dispense", "numberOfRepeatsAllowed")
      this_coding_system     = API.dig_with_specified_array_location(medication_data, 0, "content", "contained", "array", "code", "coding", "array", "system")
      this_code              = API.dig_with_specified_array_location(medication_data, 0, "content", "contained", "array", "code", "coding", "array", "code")
      Medication.new(this_id, this_value, this_status, this_prescriber, this_written_date, this_dosage_value, this_dosage_units, this_dosage_text, this_dispense_quantity, this_dispense_repeats, this_coding_system, this_code)
    end

    def url(patient_pidd)
      "#{BASE_URL_CONST}#{RPATH_MED_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient_pid}#{RPATH_COUNT_100_CONST}"
    end
  end

  class Patient
    RPATH_CONST = "Patient/"

    def all
      results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{RPATH_PARAMS_CONST}#{RPATH_COUNT_100_CONST}")
      results_hash = JSON.parse(results.body)
      patients = results_hash["entry"].map do |patient_data|
        extract_object_from_data(patient_data["content"])
      end
    end

    def update(patient)
      results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{patient.pid}#{RPATH_PARAMS_CONST}")
      results_hash = JSON.parse(results.body)
      patient.fname = results_hash["name"][0]["given"].first
      patient.lname = results_hash["name"][0]["family"].first
      patient
    end

    def find(pid)
      results = HTTParty.get("#{BASE_URL_CONST}#{RPATH_PAT_CONST}#{pid}#{RPATH_PARAMS_CONST}")
      results_hash = JSON.parse(results.body)
      extract_object_from_data(results_hash)
    end

    private

    def extract_object_from_data(patient_data)
      this_pid        = API.dig_with_specified_array_location(patient_data, 0, "identifier", "array", "value")
      this_name_first = API.dig_with_specified_array_location(patient_data, 0, "name", "array", "given", "array")
      this_name_last  = API.dig_with_specified_array_location(patient_data, 0, "name", "array", "family", "array")
      Patient.new(this_pid, this_name_first, this_name_last)
    end
  end
end
