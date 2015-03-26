class Patient
  attr_accessor :fname, :lname, :pid, :fhir, :observations
  attr_writer :conditions, :medications

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
    if observations.map(&:comment).include?("Body Weight")
      body_weight_observation = observations.select{|observation| observation.comment == "Body Weight"}
      # binding.pry
      weight = body_weight_observation.first.display.gsub(/[^\d,\.]/, '').to_i
      weight = weight.to_s
      weight += " kg"
    else
      weight = "N/A"
    end
    weight
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
