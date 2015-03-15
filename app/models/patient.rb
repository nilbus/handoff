class Patient
  attr_accessor :fname, :lname, :pid
  @fname
  @lname
  @pid

  def initialize(fname,lname,pid)
    @fname = fname
    @lname = lname
    @pid = pid
  end

  def FullName
    '#{fname} #{lname}'
  end

  def observations
    @observations ||= API.patient_observations(self)
  end
end
