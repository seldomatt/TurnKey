module Turnkey

  module Proxy
    include Turnkey::Sanitizers

    def self.included(base)
      base.extend(ClassMethods)
    end

    def encodeWithCoder(encoder)
      self.class.tk_vars = instance_variables
      instance_variables.each do |prop|
        reader_sig = reader_sig_for(prop)
        encoder.encodeObject(self.send(reader_sig), forKey: reader_sig)
      end
    end

    def initWithCoder(decoder)
      init.tap do
        property_list = self.class.tk_vars
        property_list.each do |prop|
          value = decoder.decodeObjectForKey(reader_sig_for(prop))
          self.send(writer_sig_for(prop), value) if value
        end
      end
    end

    module ClassMethods

      def tk_vars=(vars)
        instance_eval do
          @@vars ||= []
          @@vars = @@vars | vars
        end
      end

      def tk_vars
        instance_eval do
          @@vars
        end
      end
    end
  end
end