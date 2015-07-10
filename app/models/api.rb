class API
  BASE_URL_CONST = "https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/"
  RPATH_PARAMS_CONST = "?_format=json"
  RPATH_FOR_PATIENT_PREFIX_CONST = "&subject=Patient/"
  RPATH_COUNT_100_CONST = "&_count=100"

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
    self.class.const_get(type.to_s.singularize.classify)
  end

  class Assessment
    attr_accessor :patient

    def initialize(patient)
      @patient = patient
    end

    def fetch_assessments
      assessments = []
      next_page_url = url
      while next_page_url.present?
        additional_assessments, next_page_url = fetch_assessments_page(next_page_url)
        assessments += additional_assessments
      end
      assessments
    end

    def fetch_assessments_page(page_url)
      response = HTTParty.get(page_url)
      results = JSON.parse(response.body)
      assessments = results["entry"].map do |assessment|
        extract_object_from_data(assessment)
      end
      next_page = NextPage.new(results).url
      assessment, next_page
    end
  end

  class NextPage
    attr_accessor :results

    def initialize(results)
      @results = results
    end

    def url
      next_link_label, next_link_url = extract_url_from_line(1)
      next_link_label, next_link_url = extract_url_from_line(2) unless next_link_label == 'next'
      next_link_url if next_link_label == 'next'
    end

    private

    def extract_url_from_line(line_index)
      data = ResponseData.new(results)
      next_link_label = data.get(line_index, "link", "array", "rel")
      next_link_url   = data.get(line_index, "link", "array", "href")
      next_link_label, next_link_url
    end
  end

  class Observation < Assessment
    RPATH_CONST = "Observation/"

    def extract_object_from_data(observation_data)
      # id, value, units, comment, pub_date, status, reliability, code_system, code, display_div
      data = ResponseData.new(observation_data)
      id          = data.get(0, "id")
      value       = data.get(0, "content", "valueQuantity", "value")
      units       = data.get(0, "content", "valueQuantity", "units")
      comment     = data.get(0, "content", "comments")
      date        = data.get(0, "con tent", "appliesDateTime")
      status      = data.get(0, "content", "status")
      reliability = data.get(0, "content", "reliability")
      code_system = data.get(0, "content", "name", "coding", "array", "system")
      code        = data.get(0, "content", "name", "coding", "array", "code")
      code_text   = data.get(0, "content", "name", "coding", "array", "display")
      display     = data.get(0, "content", "text", "div")
      ::Observation.new(display, id, value, units, comment, date, status, reliability, code_system, code, code_text)
    end

    def url
      "#{BASE_URL_CONST}#{RPATH_OBS_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient.pid}#{RPATH_COUNT_100_CONST}"
    end
  end

  class Condition < Assessment
    RPATH_CONST = "Condition/"

    def extract_object_from_data(condition_data)
      #id, value, onset_date, status, code_system, code
      data = ResponseData.new(condition_data)
      id          = data.get(0, "id")
      value       = data.get(0, "content", "code", "coding", "array", "display")
      onset_date  = data.get(0, "content", "onsetDate")
      status      = data.get(0, "content", "status")
      code_system = data.get(0, "content", "code", "coding", "array", "system")
      code        = data.get(0, "content", "code", "coding", "array", "code")
      ::Condition.new(id, value, onset_date, status, code_system, code)
    end

    def url(patient_pidd)
      "#{BASE_URL_CONST}#{RPATH_CON_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient_pid}#{RPATH_COUNT_100_CONST}"
    end
  end

  class Medication < Assessment
    RPATH_CONST = "MedicationPrescription/"

    def extract_object_from_data(medication_data)
      #id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code
      data = ResponseData.new(medication_data)
      id                = data.get(0, "id")
      value             = data.get(0, "content", "medication", "display")
      status            = data.get(0, "content", "status")
      prescriber        = data.get(0, "content", "prescriber", "display")
      written_date      = data.get(0, "content", "dateWritten")
      dosage_value      = data.get(0, "content", "dosageInstruction", "array", "doseQuantity", "value")
      dosage_units      = data.get(0, "content", "dosageInstruction", "array", "doseQuantity", "units")
      dosage_text       = data.get(0, "content", "dosageInstruction", "array", "text")
      dispense_quantity = data.get(0, "content", "dispense", "quantity", "value")
      dispense_repeats  = data.get(0, "content", "dispense", "numberOfRepeatsAllowed")
      coding_system     = data.get(0, "content", "contained", "array", "code", "coding", "array", "system")
      code              = data.get(0, "content", "contained", "array", "code", "coding", "array", "code")
      ::Medication.new(id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code)
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
      data = ResponseData.new(patient_data)
      pid        = data.get(0, "identifier", "array", "value")
      name_first = data.get(0, "name", "array", "given", "array")
      name_last  = data.get(0, "name", "array", "family", "array")
      ::Patient.new(pid, name_first, name_last)
    end
  end

  class ResponseData
    attr_accessor :assessment

    def initialize(assessment)
      @assessment = assessment
    end

    def get(array_location, *path)
      path.reduce(assessment) do |location, key|
        if location && location.is_a?(Hash)
          location[key]
        elsif location && location.kind_of?(Array) && location.length > 0
          location[array_location]
        else
          nil
        end
      end
    end
  end
end
