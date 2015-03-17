class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    if user_signed_in?
      redirect_to handoffs_path
    end
  end

  def about
  end

  def contact
  end
end
