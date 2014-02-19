module Turnkey

  class Utility
    extend Sanitizers

    def self.defineProtocols(instance)
      return if alreadyDefined?(instance)

      includeCoderProtocols(instance)

      instance.instance_variables.each do |prop|
        if instance.respond_to?(reader_sig_for(prop))
          ref = instance.send(reader_sig_for(prop))
          defineProtocols(ref)
        end
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