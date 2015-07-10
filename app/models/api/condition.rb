class API
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
end
