module MonkeyCatch
  class SingletonMethodsObserver
    include Procto.call, Concord.new(:constants)

    def call
      constants_with(:methods).flat_map(&method(:method_objects))
    end

    private

    def constants_with(method_name)
      constants.select do |const|
        const.respond_to?(method_name)
      end
    end

    def method_objects(const)
      const.methods(false).flat_map(&const.method(:method))
    end
  end
end
