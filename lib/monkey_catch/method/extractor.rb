module MonkeyCatch
  module Method
    class Extractor
      include Procto.call, Concord.new(:constants, :extractor_message)

      def call
        constants_with(names_message).flat_map(&method(:const_methods))
      end

      private

      def method_names(const)
        const.send(names_message, false)
      end

      def const_methods(const)
        method_names(const).flat_map(&const.method(extractor_message))
      end

      def constants_with(method_name)
        constants.select do |const|
          const.respond_to?(method_name)
        end
      end

      def names_message
        :"#{extractor_message}s"
      end

      class Instance < Extractor
        MESSAGE = :instance_method

        def initialize(constants)
          super(constants, MESSAGE)
        end
      end

      class Singleton < Extractor
        MESSAGE = :method

        def initialize(constants)
          super(constants, MESSAGE)
        end
      end
    end
  end
end
