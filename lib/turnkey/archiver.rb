module Turnkey

  class Archiver


    def self.archive(instance, key)
      defineEncodeWithCoder(instance)
      data = NSKeyedArchiver.archivedDataWithRootObject(instance)
      p "happens"
      NSUserDefaults.standardUserDefaults[key.to_s] = data
    end

    private

    #def self.defineInitWithCoder(instance)
    #  instance.class.class_eval {
    #    define_method(:initWithCoder) { |decoder|
    #      true
    #    }
    #  }
    #end

    #[:@title, :@album, :@artist]

    def self.defineEncodeWithCoder(instance)
      instance.class.class_eval {
        include Turnkey::Sanitizers
        define_method(:encodeWithCoder) { |encoder|
          instance.instance_variables.each do |prop|
            reader_sig = reader_sig_for(prop)
            encoder.encodeObject(instance.send(reader_sig), forKey: reader_sig)
          end
        }
      }
    end


  end

  module Sanitizers

    def reader_sig_for(property)
      property.to_s.delete("@")
    end

  end
end