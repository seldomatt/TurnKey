module Turnkey

  module Proxy
    include Turnkey::Sanitizers

    def encodeWithCoder(encoder)
      self.class.class_variable_set(:@@props, instance_variables)
      instance_variables.each do |prop|
        reader_sig = reader_sig_for(prop)
        encoder.encodeObject(self.send(reader_sig), forKey: reader_sig)
      end
    end

    def initWithCoder(decoder)
      init.tap do
        property_list = self.class.class_variable_get(:@@props)
        property_list.each do |prop|
          value = decoder.decodeObjectForKey(reader_sig_for(prop))
          self.send(writer_sig_for(prop), value) if value
        end
      end
    end

  end

end