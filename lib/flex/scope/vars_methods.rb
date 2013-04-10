module Flex
  class Scope
    module VarsMethods

      include Scope::Utils

      def query(q)
        hash = q.is_a?(Hash) ? q : {:query => q}
        deep_merge :query => hash
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

      # meaningful alias of deep_merge
      def variables(*variables)
        deep_merge *variables
      end

      def index(val)
        deep_merge :index => val
      end

      def type(val)
        deep_merge :type => val
      end

      # script_fields(:my_field       => 'script ...',                   # simpler form
      #               :my_other_field => {:script => 'script ...', ...}) # ES API
      def script_fields(hash)
        hash.keys.each do |k|
          v = hash[k]
          script = v.is_a?(String) ? v : v[:script]
          hash[k][:script] = script.gsub(/\n+\s*/,' ')
        end
        deep_merge :script_fields => hash
      end

      def facets(hash)
        deep_merge :facets => hash
      end

      def highlight(hash)
        deep_merge :highlight => hash
      end

      def metrics
        deep_merge :params => {:search_type => 'count'}
      end

    end
  end
end
