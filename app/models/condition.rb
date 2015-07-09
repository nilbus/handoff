class Condition
  attr_accessor :id, :value, :onset_date, :status, :code_system, :code

  def initialize(id, value, onset_date, status, code_system, code)
    @id = id
    @value = value
    @onset_date = onset_date.try :to_datetime
    @status = status
    @code_system = code_system
    @code = code
  end

end
