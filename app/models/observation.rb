class Observation
  attr_accessor :display, :id, :value, :units, :comment, :date, :status, :reliability, :code_system, :code, :code_display

  def initialize(display, id, value, units, comment, date, status, reliability, code_system, code, code_display)
    @display = display
    @id = id
    @value = value
    @units = units
    @comment = comment
    @date = date != nil ? date.to_datetime : nil
    @status = status
    @reliability = reliability
    @code_system = code_system
    @code = code
    @code_display = code_display
  end

end
