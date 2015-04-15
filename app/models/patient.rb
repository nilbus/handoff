class Patient
  include ActiveModel::Model

  attr_accessor :fname, :lname, :pid, :fhir, :observations, :birthday
  attr_writer :conditions, :medications
  alias :to_param :pid

  class << self
    def all
      API.all_patients
    end
  end

  def initialize(pid, fname = nil, lname = nil)
    @pid = pid
    @fname = fname
    @lname = lname
  end

  def full_name
    API.update_patient(self) unless @got_full_name || @fname.present? && @lname.present?
    @got_full_name = true
    "#{@fname} #{@lname}"
  end

  def observations
    return @observations if @got_observations
    API.update_patient_observations(self)
    @got_observations = true
    @observations
  end

  def groupedAndSortedObservations
    allObservations = observations()
    grouped = Hash.new
    allObservations.each do |observation|
      if !grouped.has_key?(observation.code_display)
          grouped[observation.code_display] = []
      end
      grouped[observation.code_display] << observation
    end
    grouped.each do |key, observations|
        grouped[key] = observations.sort! { |a,b| b.date <=> a.date }
    end
    grouped
  end

  def weight
    if observations.map(&:code_display).include?("Body Weight")
      body_weight_observation = [observations.select{|observation| observation.code_display == "Body Weight"}].flatten.sort_by(&:date).last
      weight = body_weight_observation.value.to_s + " " +body_weight_observation.units
    else
      weight = "N/A"
    end
    weight
  end

  def birthday
    from = 0.0
    to = Time.now
    random_number = Random.new(@pid.gsub('.', '').gsub('-', '').to_i).rand
    # binding.pry
    (Time.at(from + random_number * (to.to_f - from.to_f))-25.years).to_s.gsub(/\d{2}:\d{2}:\d{2} -\d{4}/, '').strip
  end

  def age
    birthday_object = Time.parse(birthday)
    age = Date.today.year - birthday_object.year
  end

  def height
    if observations.map(&:code_display).include?("Body Height")
      height_observation = [observations.select{|observation| observation.code_display == "Body Height"}].flatten.sort_by(&:date).last
      height_number = height_observation.value
        if height_observation.units == "in"
          height_feet = (height_number / 12).floor 
          height_inches = height_number % 12
        else
          height_feet = (height_number / 30).floor
          height_inches = (height_number / 30 / 2.54).round
        end
      height = "#{height_feet} ft. #{height_inches} in." 
    else
      height = "N/A"
    end
    height
  end

  def conditions
    return @conditions if @got_conditions
    API.update_patient_conditions(self)
    @got_conditions = true
    @conditions
  end

  def groupedAndSortedConditions
    allConditons = conditions()
    grouped = Hash.new
    allConditons.each do |condition|
      if !grouped.has_key?(condition.value)
          grouped[condition.value] = []
      end
      grouped[condition.value] << condition
    end
    grouped.each do |key, conditions|
        grouped[key] = conditions.sort! { |a,b| b.onset_date <=> a.onset_date }
    end
    grouped
  end

  def medications
    return @medications if @got_medications
    API.update_patient_medications(self)
    @got_medications = true
    @medications
  end

  def groupedAndSortedMedications
    allMedications = medications()
    grouped = Hash.new
    allMedications.each do |medication|
      if !grouped.has_key?(medication.value)
          grouped[medication.value] = []
      end
      grouped[medication.value] << medication
    end
    grouped.each do |key, medications|
        grouped[key] = medications.sort! { |a,b| b.written_date <=> a.written_date }
    end
    grouped
  end

end
