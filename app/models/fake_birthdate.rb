class FakeBirthdate
  def initialize(patient)
    @random_seed = patient.pid.gsub('.', '').gsub('-', '').to_i
  end

  def random_reasonable_birthdate
    from = 0.0
    to = Time.now
    random_number = Random.new(@random_seed).rand
    Time.at(from + random_number * (to.to_f - from.to_f)) - 25.years
  end

  def to_s
    formatted random_reasonable_birthdate
  end

  private

  def formatted(date)
    date.to_s.gsub(/\d{2}:\d{2}:\d{2} -\d{4}/, '').strip
  end
end
