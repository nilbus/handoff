class Observation
  attr_accessor :id, :value, :units, :comment, :pub_date, :status, :reliability, :code_system, :code

  def initialize(id, value, units, comment, pub_date, status, reliability, code_system, code)
    @id = id
    @value = value
    @units = units
    @comment = comment
    @pub_date = pub_date
    @status = status
    @reliability = reliability
    @code_system = code_system
    @code = code
  end

end
