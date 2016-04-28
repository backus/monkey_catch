module MonkeyCatch
  class Diff
    include Concord.new(:context, :constants), Procto.call(:compare)

    def initialize(context, constants = ConstantList.lookup(Object))
      super(context, constants)
    end

    def compare
      before, after = record_diff

      filter(after - before)
    end

    private

    def filter(results)
      klasses = results.map(&:klass)

      results.reject do |method|
        next true unless method.klass && method.klass.respond_to?(:ancestors)
        next if method.klass.equal?(BasicObject)

        method.klass.ancestors.drop(1).any? do |ancestor|
          klasses.include?(ancestor)
        end
      end
    end

    def record_diff
      before = record

      context.call

      after  = record

      [before, after]
    end

    def record
      instance_methods = Method::Extractor::Instance.call(constants).map do |meth|
        Method.new(meth.owner, meth)
      end

      singleton_methods = Method::Extractor::Singleton.call(constants).map do |meth|
        Method.new(meth.receiver, meth)
      end

      Set.new(instance_methods + singleton_methods)
    end
  end
end
