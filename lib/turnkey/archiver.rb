module Turnkey

  class Archiver
    extend Turnkey::Sanitizers

    def self.archive(instance, key)
      Turnkey::Utility.defineProtocols(instance)
      extend_protocols_to_object_references(instance)
    end

    private

    def self.extend_protocols_to_object_references(instance)
      instance.instance_variables.each do |prop|
        value = instance.send(reader_sig_for(prop))
        Turnkey::Utility.defineProtocols(value)
      end
    end
  end
end