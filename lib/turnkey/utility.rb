module Turnkey

  class Utility
    extend Sanitizers

    def self.defineProtocols(instance)
      return if instance.respondsToSelector("encodeWithCoder:") && instance.respondsToSelector("initWithCoder:")
      instance.class.class_eval {
        include Turnkey::Proxy
      }
    end

    def self.extend_protocols_to_object_references(instance)
      instance.instance_variables.each do |prop|
        value = instance.send(reader_sig_for(prop))
        defineProtocols(value)
      end
    end
  end
end