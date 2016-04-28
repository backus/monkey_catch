module MonkeyCatch
  class ConstantList
    extend Forwardable

    def self.lookup(root)
      items = Search.search([root]).all
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

      def exhausted?
        unsearched.empty?
      end
    end

    class Search
      def self.search(roots)
        new([], roots).search
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
        unsearched.flat_map(&method(:search_constant))
      end

      def unsearched
        set.unsearched.reject do |item|
          item.equal?(Module)
        end
      end

      def search_constant(constant)
        return [] unless constant.respond_to?(:constants)

        constant.constants.map do |name|
          begin
            constant.const_get(name)
          rescue NameError, LoadError => error
            # warn "Could not resolve #{constant}::#{name}: #{error.message}"
          end
        end
      end
    end
  end
end
