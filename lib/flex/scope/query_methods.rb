module Flex
  class Scope

    module Query

      include Loader
      flex.load_source File.expand_path('../queries.yml', __FILE__)

    end

    module QueryMethods

      #    MyModel.find(ids, vars={})
      #    - ids can be a single id or an array of ids
      #
      #    MyModel.find '1Momf4s0QViv-yc7wjaDCA'
      #      #=> #<MyModel ... color: "red", size: "small">
      #
      #    MyModel.find ['1Momf4s0QViv-yc7wjaDCA', 'BFdIETdNQv-CuCxG_y2r8g']
      #      #=> [#<MyModel ... color: "red", size: "small">, #<MyModel ... color: "bue", size: "small">]
      #
      def find(ids, *vars)
        raise ArgumentError, "Empty argument passed (got #{ids.inspect})" \
              if ids.nil? || ids.respond_to?(:empty?) && ids.empty?
        wrapped = ids.is_a?(::Array) ? ids : [ids]
        result  = Query.ids self, *vars, :ids => wrapped
        (ids.is_a?(::Array) || result.variables[:raw_result]) ? result : result.first
      end

      # it limits the size of the query to the first document and returns it as a single document object
      def first(*vars)
        result = Query.get params(:size => 1), *vars
        result.variables[:raw_result] ? result : result.first
      end

      # it limits the size of the query to the last document and returns it as a single document object
      def last(*vars)
        result = Query.get params(:from => count-1, :size => 1), *vars
        result.variables[:raw_result] ? result : result.first
      end

      # will retrieve all documents, the results will be limited by the default :size param
      # use #scan_all if you want to really retrieve all documents (in batches)
      def all(*vars)
        Query.get self, *vars
      end

      def each(*vars, &block)
        all(*vars).each &block
      end

      def destroy(*vars)
        Query.destroy self, *vars
      end

      # scan_search: the block will be yielded many times with an array of batched results.
      # You can pass :scroll and :size as params in order to control the action.
      # See http://www.elasticsearch.org/guide/reference/api/search/scroll.html
      def scan_all(*vars, &block)
        Query.flex.scan_search(:get, self, *vars, &block)
      end

      # performs a count search on the scope
      def count(*vars)
        result = Query.flex.count_search(:get, self, *vars)
        result['hits']['total']
      end

    end
  end
end
