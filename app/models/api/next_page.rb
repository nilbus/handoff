class API
  class NextPage
    attr_accessor :results

    def initialize(results)
      @results = results
    end

    def url
      next_link_label, next_link_url = extract_url_from_line(1)
      next_link_label, next_link_url = extract_url_from_line(2) unless next_link_label == 'next'
      next_link_url if next_link_label == 'next'
    end

    private

    def extract_url_from_line(line_index)
      data = ResponseData.new(results)
      next_link_label = data.get(line_index, "link", "array", "rel")
      next_link_url   = data.get(line_index, "link", "array", "href")
      next_link_label, next_link_url
    end
  end
end
