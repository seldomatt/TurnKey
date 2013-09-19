module Turnkey

  class Utility

    def self.defineProtocols(instance)
      return if instance.respondsToSelector("encodeWithCoder:") && instance.respondsToSelector("initWithCoder:")
      instance.class.class_eval {
        include Turnkey::Proxy
      }
    end
  end

end