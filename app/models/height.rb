class Height
  def initialize(observation)
    return unless observation.present?
    @height   = observation.value
    @imperial = (observation.units == 'in')
  end

  def feet
    if @imperial
      (@height / 12).floor
    else
      (@height / 30).floor
    end
  end

  def inches
    if @imperial
      @height % 12
    else
      (@height / 30 / 2.54).round
    end
  end

  def to_s
    return 'N/A' unless @height.present?
    "#{feet} ft. #{inches} in."
  end
end
