class API
  BASE_URL_CONST = "https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/"
  RPATH_PARAMS_CONST = "?_format=json"
  RPATH_FOR_PATIENT_PREFIX_CONST = "&subject=Patient/"
  RPATH_COUNT_100_CONST = "&_count=100"

  def all_patients
    Patient.new.all
  end

  def update_patient(patient)
    Patient.new.update(patient)
  end

  def update_patient_assessments(type, patient)
    patient.send "#{type}=", type_class.new(patient).fetch_assessments
  end

  private

  def type_class(type)
    self.class.const_get(type.to_s.classify)
  end
end
