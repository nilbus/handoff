class Patient
  def self.search(query)
    API.patient_search(query)
  end

  def initialize(attributes)
    @attributes = attributes
  end

  def name
    @attributes['name']
  end

  def observations
    @observations ||= API.patient_observations(self)
  end
end
