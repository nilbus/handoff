class PatientsController < ApplicationController
  def index
    # @dummy_patient = Patients.all.first
    @directory = API.all_patients
  end

  def show
    @patient_id = params[:id]
    @patient_data = Patient.new(@patient_id)
    @patient_data.get_data
  end
end
