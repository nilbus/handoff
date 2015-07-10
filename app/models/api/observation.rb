class API
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
end
