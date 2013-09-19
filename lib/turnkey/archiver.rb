module Turnkey

  class Archiver


    def self.archive(instance, key)
      defineEncodeWithCoder(instance)
      data = NSKeyedArchiver.archivedDataWithRootObject(instance)
      NSUserDefaults.standardUserDefaults[key.to_s] = data
    end

  end

end