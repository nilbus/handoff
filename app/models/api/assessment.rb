class API
  class Assessment
    attr_accessor :patient

    def initialize(patient)
      @patient = patient
    end

    def fetch_assessments
      assessments = []
      next_page_url = url
      while next_page_url.present?
        additional_assessments, next_page_url = fetch_assessments_page(next_page_url)
        assessments += additional_assessments
      end
      assessments
    end

    def fetch_assessments_page(page_url)
      response = HTTParty.get(page_url)
      results = JSON.parse(response.body)
      assessments = results["entry"].map do |assessment|
        extract_object_from_data(assessment)
      end
      next_page = NextPage.new(results).url
      assessment, next_page
    end
  end
end
