module MonkeyCatch
  class Method
    include Anima.new(:owner, :name, :location, :lineno, :source)
  end

  InstanceMethod  = Class.new(Method)
  SingletonMethod = Class.new(Method)

  class Diff
    include Concord.new(:context, :constants), Procto.call(:compare)

    def initialize(context)
      constants = ConstantList.lookup(Object)
      super(context, constants)
    end

    def compare
      before, _, after = record, context.call, record

      after - before
    end

    private

    def record
      instance_methods = InstanceMethodsObserver.call(constants).map do |instance_method|
        source_location = if instance_method.source_location
          instance_method.source_location
        else
          ['no source info', -1]
        end

        source = instance_method.respond_to?(:source) ? instance_method.source : ''

        InstanceMethod.new(
          owner:    instance_method.owner,
          name:     instance_method.name,
          location: source_location.fetch(0),
          lineno:   source_location.fetch(1),
          source:   source
        )
      end

      singleton_methods = SingletonMethodsObserver.call(constants).map do |singleton_method|
        source_location = if singleton_method.source_location
          singleton_method.source_location
        else
          ['no source info', -1]
        end

        source = singleton_method.respond_to?(:source) ? singleton_method.source : ''

        SingletonMethod.new(
          owner:    singleton_method.receiver,
          name:     singleton_method.name,
          location: source_location.fetch(0),
          lineno:   source_location.fetch(1),
          source:   source
        )
      end

      Set.new(instance_methods + singleton_methods)
    end
  end
end
