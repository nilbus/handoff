class Observation
  attr_accessor :display, :id, :value, :units, :comment, :pub_date, :status, :reliability, :code_system, :code

  def initialize(display, id, value, units, comment, pub_date, status, reliability, code_system, code)
    @display = display
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
