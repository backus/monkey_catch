module MonkeyCatch
  class InstanceMethodsObserver
    include Procto.call, Concord.new(:constants)

    def call
      constants_with(:instance_methods).flat_map(&method(:instance_method_objects))
    end

    private

    def constants_with(method_name)
      constants.select do |const|
        const.respond_to?(method_name)
      end
    end

    def instance_method_objects(const)
      const.instance_methods(false).flat_map(&const.method(:instance_method))
    end
  end
end
