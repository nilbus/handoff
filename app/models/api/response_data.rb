class API
  class ResponseData
    attr_accessor :assessment

    def initialize(assessment)
      @assessment = assessment
    end

    def get(array_location, *path)
      path.reduce(assessment) do |location, key|
        if location && location.is_a?(Hash)
          location[key]
        elsif location && location.kind_of?(Array) && location.length > 0
          location[array_location]
        else
          nil
        end
      end
    end
  end
end
