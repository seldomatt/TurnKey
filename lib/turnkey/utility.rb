
motion_require "sanitizers"
module Turnkey

  class Utility
    extend Sanitizers

    #def self.defineProtocols(instance)
    #  return if instance.respondsToSelector("encodeWithCoder:") && instance.respondsToSelector("initWithCoder:")
    #  instance.class.class_eval {
    #    include Turnkey::Proxy
    #  }
    #end
    #
    #def self.extend_protocols_to_object_references(instance)
    #  instance.instance_variables.each do |prop|
    #    value = instance.send(reader_sig_for(prop))
    #    defineProtocols(value)
    #  end
    #end

    def self.defineProtocols(instance)
      return if alreadyDefined?(instance)

      includeCoderProtocols(instance)

      instance.instance_variables.each do |prop|
        ref = instance.send(reader_sig_for(prop))
        defineProtocols(ref)
      end
    end

    private

    def self.alreadyDefined?(instance)
      instance.respondsToSelector("encodeWithCoder:") && instance.respondsToSelector("initWithCoder:")
    end

    def self.includeCoderProtocols(instance)
      instance.class.class_eval {
        include Turnkey::Proxy
      }
    end
  end
end