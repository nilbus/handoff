class PatientsController < ApplicationController
  def index
    # @dummy_patient = Patients.all.first
    @directory = Patient.all
  end

  def show
    @patient_id = params[:id]
    @patient_data = Patient.new(@patient_id)
  end
end
