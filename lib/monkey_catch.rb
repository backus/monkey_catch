require 'forwardable'
require 'tsort'
require 'set'

require 'anima'
require 'adamantium'
require 'concord'
require 'procto'

require 'monkey_catch/version'
require 'monkey_catch/constant_list'
require 'monkey_catch/method/extractor'
require 'monkey_catch/method'
require 'monkey_catch/diff'

module MonkeyCatch
  def self.report(&block)
    diff = Diff.call(block)

    diff.each do |meth|
      case meth
      when Method::Instance
        puts "Instance method monkey patch:  `#{meth.klass}##{meth.name}`"
      when Method::Singleton
        puts "Singleton method monkey patch: `#{meth.klass}.#{meth.name}`"
      end
    end
  end
end
