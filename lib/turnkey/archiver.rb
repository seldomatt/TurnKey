module Turnkey

  class Archiver

    def self.define_protocols(instance)
      instance.class.class_eval do
        define_method(:initWithCoder) {|decoder| true}
      end
    end

  end
end