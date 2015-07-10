class API
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
      Patient.new(pid, name_first, name_last)
    end
  end
end
