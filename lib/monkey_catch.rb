require 'forwardable'
require 'tsort'
require 'set'

require 'anima'
require 'adamantium'
require 'concord'
require 'procto'

require 'monkey_catch/version'
require 'monkey_catch/instance_methods_observer'
require 'monkey_catch/singleton_methods_observer'
require 'monkey_catch/constant_list'
require 'monkey_catch/diff'

module MonkeyCatch
  def self.report(&block)
    diff = Diff.call(block)

    diff.each do |meth|
      case meth
      when InstanceMethod
        puts "#{meth.owner}##{meth.name}"
      when SingletonMethod
        puts "#{meth.owner}.#{meth.name}"
      else
        fail 'unknown error'
      end
    end
  end
end
