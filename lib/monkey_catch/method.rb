module MonkeyCatch
  module Method
    def self.new(klass, meth)
      type = case meth
             when ::Method then Singleton
             when UnboundMethod then Instance
             end

      path, lineno = meth.source_location || ['No location', -1]

      type.new(
        klass:    klass,
        name:     meth.name,
        location: path,
        lineno:   lineno
      )
    end

    class Instance
      include Anima.new(:klass, :name, :location, :lineno)
    end

    class Singleton
      include Anima.new(:klass, :name, :location, :lineno)
    end
  end
end
