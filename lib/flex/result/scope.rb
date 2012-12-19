module Flex
  class Result
    module Scope

      def get_docs
        return self if variables[:raw_result]
        case self
        when Flex::Result::Search
          self['hits']['hits']
        when Flex::Result::MultiGet
          self['docs']
        else
          self
        end
      end

    end
  end
end
