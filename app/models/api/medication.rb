class API
  class Medication < Assessment
    RPATH_CONST = "MedicationPrescription/"

    def extract_object_from_data(medication_data)
      #id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code
      data = ResponseData.new(medication_data)
      id                = data.get(0, "id")
      value             = data.get(0, "content", "medication", "display")
      status            = data.get(0, "content", "status")
      prescriber        = data.get(0, "content", "prescriber", "display")
      written_date      = data.get(0, "content", "dateWritten")
      dosage_value      = data.get(0, "content", "dosageInstruction", "array", "doseQuantity", "value")
      dosage_units      = data.get(0, "content", "dosageInstruction", "array", "doseQuantity", "units")
      dosage_text       = data.get(0, "content", "dosageInstruction", "array", "text")
      dispense_quantity = data.get(0, "content", "dispense", "quantity", "value")
      dispense_repeats  = data.get(0, "content", "dispense", "numberOfRepeatsAllowed")
      coding_system     = data.get(0, "content", "contained", "array", "code", "coding", "array", "system")
      code              = data.get(0, "content", "contained", "array", "code", "coding", "array", "code")
      Medication.new(id, value, status, prescriber, written_date, dosage_value, dosage_units, dosage_text, dispense_quantity, dispense_repeats, coding_system, code)
    end

    def url(patient_pidd)
      "#{BASE_URL_CONST}#{RPATH_MED_CONST}#{RPATH_PARAMS_CONST}#{RPATH_FOR_PATIENT_PREFIX_CONST}#{patient_pid}#{RPATH_COUNT_100_CONST}"
    end
  end
end
