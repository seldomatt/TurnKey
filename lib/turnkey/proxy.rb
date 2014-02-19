module Turnkey

  module Proxy
    include Turnkey::Sanitizers

    def encodeWithCoder(encoder)
      #self.class.tk_vars = instance_variables
      instance_variables.each do |prop|
        if self.respond_to?(reader_sig_for(prop))
          reader_sig = reader_sig_for(prop)
          encoder.encodeObject(self.send(reader_sig), forKey: reader_sig)
        end
      end
    end

    def initWithCoder(decoder)
      init.tap do
        property_list = Cache.attributesForClass(self.class)
        property_list.each do |prop|
          value = decoder.decodeObjectForKey(reader_sig_for(prop))
          if self.respond_to?(writer_sig_for(prop)) && value
            self.send(writer_sig_for(prop), value)
          end
        end
      end
    end
  end
end