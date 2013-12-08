motion_require "proxy"
module Turnkey

  def archive(instance, key)
    if instance.is_a? Array
      archive_array(instance, key)
    else
      archive_instance(instance, key)
    end
    true
  end

  def unarchive(key)
    data = user_defaults[key]
    archived_klasses = Cache.classes
    archived_klasses.each do |klass|
      klass.class_eval {
        include Turnkey::Proxy
      }
    end
    NSKeyedUnarchiver.unarchiveObjectWithData(data)
  end

  module_function :archive, :unarchive

  private

  def self.archive_instance(instance, key)
    Cache.update(instance)
    Utility.defineProtocols(instance)
    archived_data = NSKeyedArchiver.archivedDataWithRootObject(instance)
    user_defaults[key] = archived_data
  end

  def self.archive_array(array, key)
    array.each { |inst| Utility.defineProtocols(inst) }
    archive_instance(array, key)
  end

  def self.user_defaults
    NSUserDefaults.standardUserDefaults
  end

end