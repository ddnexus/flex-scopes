module Flex
  class Scope
    module VarsMethods

      def query(q)
        hash = q.is_a?(Hash) ? q : {:query => q}
        deep_merge :query => hash
      end

      # accepts also :any_term => nil for missing values
      def terms(value)
        terms, missing_fields = {}, []
        value.each { |f, v| v.nil? ? missing_fields.push({ :missing => f }) : (terms[f] = v) }
        terms, term = terms.partition{|k,v| v.is_a?(Array)}
        deep_merge :terms => Hash[terms], :term => Hash[term], :_missing_fields => missing_fields
      end

      # accepts one or an array or a list of filter structures
      def filters(*value)
        deep_merge :filters => array_value(value)
      end

      # accepts one or an array or a list of sort structures documented at
      # http://www.elasticsearch.org/guide/reference/api/search/sort.html
      # doesn't probably support the multiple hash form, but you can pass an hash as single argument
      # or an array or list of hashes
      def sort(*value)
        deep_merge :sort => array_value(value)
      end

      # the fields that you want to retrieve (limiting the size of the response)
      # the returned records will be frozen, and the missing fileds will be nil
      # pass an array eg fields.([:field_one, :field_two])
      # or a list of fields e.g. fields(:field_one, :field_two)
      def fields(*value)
        deep_merge :params => {:fields => array_value(value)}
      end

      # limits the resize of the retrieved hits
      def size(value)
        deep_merge :params => {:size => value}
      end

      # sets the :from param so it will return the nth page of size :size
      def page(value)
        deep_merge :page => value || 1
      end

      # the standard :params variable
      def params(value)
        deep_merge :params => value
      end

      def variables(*variables)
        deep_merge *variables
      end

      def index(val)
        deep_merge :index => val
      end

      def type(val)
        deep_merge :type => val
      end

      def script_fields(hash)
        hash.each_value {|v| v[:script].gsub!(/\n+\s*/,' ')}
        deep_merge :__script_fields => hash
      end

      def facets(hash)
        deep_merge :facets => hash
      end

    private

      def array_value(value)
        (value.first.is_a?(::Array) && value.size == 1) ? value.first : value
      end

    end
  end
end
