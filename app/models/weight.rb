class Weight
  def initialize(observation)
    return unless observation.present?
    @weight = observation.value
    @unit   = observation.units
  end

  def to_s
    return 'N/A' unless @weight.present?
    "#{@weight} #{@unit}"
  end
end
