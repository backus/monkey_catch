module MonkeyCatch
  class ConstantList
    extend Forwardable

    def self.lookup(root)
      items = Search.search([root]).search.all
      new(Set.new(items.to_a))
    end

    include Concord.new(:constants), Enumerable, Adamantium

    def_delegator :constants, :each

    class SearchSet
      include Concord::Public.new(:expanded, :all), Adamantium

      def unsearched
        all - expanded
      end
      memoize :unsearched

      def add(root, nested)
        self.class.new(expanded + root, all + nested)
      end

      def exhausted?
        unsearched.empty?
      end

      def searched?(item)
        expanded.include?(item)
      end
    end

    class Search
      def self.search(roots)
        new([], roots)
      end

      include Concord.new(:set), Procto.call(:search)

      def initialize(searched, unsearched)
        super(SearchSet.new(Set.new(searched), Set.new(unsearched)))
      end

      def search
        return set if set.exhausted?

        Search.new(set.all, set.all + unsearched_children).search
      end

      def unsearched_children
        set.unsearched.flat_map do |constant|
          next [] unless constant.respond_to?(:constants)
          constant.constants.map do |name|
            begin
              constant.const_get(name)
            rescue NameError, LoadError => error
              warn "Could not resolve #{constant}::#{name}: #{error.message}"
            end
          end
        end
      end
    end

    class Lookup
      class Graph
        extend Forwardable
        include Concord.new(:nodes), TSort

        def_delegators :nodes, :each_key, :fetch, :key?, :to_a
        alias_method :tsort_each_node, :each_key

        def merge(other)
          merged = (nodes.keys + other.nodes.keys).reduce({}) do |memo, key|
            memo[key] = nodes.fetch(key, []) + other.nodes.fetch(key, [])
            memo
          end

          self.class.new(merged)
        end

        def [](key)
          nodes.fetch(key, [])
        end

        def tsort_each_child(node, &block)
          self[node].each(&block)
        end
      end

      def self.call(root, dependencies)
        return dependencies if dependencies.key?(root)

        strategy = if root.respond_to?(:constants) && !root.equal?(Module)
                     Constant
                   else
                     Null
                   end

        strategy.call(root, dependencies)
      end

      class Abstract
        include Procto.call(:lookup), Concord.new(:root, :dependencies)

        def initialize(root, dependencies)
          super(root, dependencies)
        end
      end

      class Constant < Abstract
        def lookup
          nested_constants.reduce(updated_dependencies) do |memo, constant|
            Lookup.call(constant, memo)
          end
        end

        private

        def updated_dependencies
          dependencies.merge(Graph.new(root => nested_constants))
        end

        def nested_constants
          root.constants.map(&method(:try_const_get))
        end

        def try_const_get(name)
          root.const_get(name)
        rescue NameError, LoadError => error
          warn "Could not resolve #{root}::#{name}: #{error.message}"
        end
      end

      class Null < Abstract
        def lookup
          dependencies.merge(Graph.new(root => []))
        end
      end
    end
  end
end
