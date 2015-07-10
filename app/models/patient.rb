class Patient
  include ActiveModel::Model

  attr_accessor :fname, :lname, :pid, :fhir, :observations, :birthday
  attr_writer :conditions, :medications
  alias :to_param :pid

  class << self
    def all
      api.all_patients
    end
  end

  def initialize(pid, fname = nil, lname = nil)
    @pid = pid
    @fname = fname
    @lname = lname
  end

  def full_name
    api.update_patient(self) unless @got_full_name || @fname.present? && @lname.present?
    @got_full_name = true
    "#{@fname} #{@lname}"
  end

  def weight
    body_weight_observation = observations.select { |observation| observation.code_display == "Body Weight"}
    Weight.new(body_weight_observation).to_s
  end

  def birthday
    FakeBirthdate.new(patient).to_s
  end

  def age
    birthday_object = Time.parse(birthday)
    age = Date.today.year - birthday_object.year
  end

  def height
    height_observation = observations.select { |observation| observation.code_display == "Body Height" }
    Height.new(height_observation).to_s
  end

  def observations
    cache_assessments(:observations) do
      api.update_patient_assessments(:observations, self)
    end
  end

  def conditions
    cache_assessments(:conditions) do
      api.update_patient_assessments(:conditions, self)
    end
  end

  def medications
    cache_assessments(:medications) do
      api.update_patient_assessments(:medications, self)
    end
  end

  private

  def api
    @api ||= API.new
  end

  def cache_assessments(type)
    @cached_assessments ||= {}
    return @cached_assessments[type] if @cached_assessments.key?(type)
    @cached_assessments[type] = yield
  end
end
