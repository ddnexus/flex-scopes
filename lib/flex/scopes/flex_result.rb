module Flex
  module Scopes
    module FlexResult

      def flex_result(result)
        case result
        when Flex::Result::Search
          result['hits']['hits']
        when Flex::Result::MultiGet
          result['docs']
        else
          result
        end
      end

    end
  end
end
