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
        wrapped = ids.is_a?(::Array) ? ids : [ids]
        raise ArgumentError, "Empty argument passed (got #{ids.inspect})" \
            if wrapped.empty?
        result = Query.ids deep_merge(*vars, :ids => wrapped)
        (ids.is_a?(::Array) || result.variables[:raw_result]) ? result : result.first
      end

      # it limits the size of the query to the first document and returns it as a single document object
      def first(*vars)
        variables = params(:size => 1).deep_merge(*vars)
        result    = Query.get(variables)
        result.variables[:raw_result] ? result : result.first
      end

      # it limits the size of the query to the last document and returns it as a single document object
      def last(*vars)
        variables = params(:from => count-1, :size => 1).deep_merge(*vars)
        result    = Query.get(variables)
        result.variables[:raw_result] ? result : result.first
      end

      # will retrieve all documents, the results will be limited by the default :size param
      # use #scan_all if you want to really retrieve all documents (in batches)
      def all(*vars)
        variables = deep_merge(*vars)
        Query.get variables
      end

      def each(*vars, &block)
        all(*vars).each &block
      end

      def destroy(*vars)
        variables = deep_merge(*vars)
        Query.destroy variables
      end

      # scan_search: the block will be yielded many times with an array of batched results.
      # You can pass :scroll and :size as params in order to control the action.
      # See http://www.elasticsearch.org/guide/reference/api/search/scroll.html
      def scan_all(*vars, &block)
        variables = deep_merge(*vars)
        Query.flex.scan_search(:get, variables, &block)
      end

      # performs a count search on the scope
      def count(*vars)
        variables = deep_merge(*vars)
        result    = Query.flex.count_search(:get, variables)
        result['hits']['total']
      end

    end
  end
end
