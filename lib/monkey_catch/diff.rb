module MonkeyCatch
  class Diff
    include Concord.new(:context, :constants), Procto.call(:compare)

    def initialize(context)
      constants = ConstantList.lookup(Object)
      super(context, constants)
    end

    def compare
      before, after = record_diff

      after - before
    end

    private

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
