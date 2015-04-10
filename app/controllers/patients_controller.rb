class PatientsController < ApplicationController
  def index
    @directory = Patient.all
  end

  def show
    @patient_id = params[:id]
    @patient_data = Patient.new(@patient_id)
  end

  def all_birthdays
    @all_birthdays = Patient.birthdays
  end
end
