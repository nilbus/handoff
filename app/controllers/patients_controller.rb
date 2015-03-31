class PatientsController < ApplicationController
  def index
    @directory = Patient.all
  end

  def show
    @patient_id = params[:id]
    @patient_data = Patient.new(@patient_id)
  end
end
