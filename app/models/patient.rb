class Patient < ActiveRecord::Base
  include HTTParty
  class << self
    def first_name(httparty_response)
      httparty_response['name'].first['given'].first
    end

    def last_name(httparty_response)
      httparty_response['name'].first['family'].first
    end

    def full_name
      first_name + last_name
    end
  end
end