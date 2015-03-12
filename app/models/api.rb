class API
  def initialize
  end

  def patient_search(query)
    # results = query...
    patients = results.map do |result_obj|
      Patient.new(result_obj)
    end
  end

  def patient_observations(patient)
    # API call
  end
end
