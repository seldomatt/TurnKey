module Turnkey

  class Cache
    extend Turnkey::Sanitizers

    @@objs ||= []

    CACHE_KEY = 'tk-cache'

    def self.cache
      NSUserDefaults.standardUserDefaults[CACHE_KEY] || {}
    end

    def self.update(instance_or_array)
      if instance_or_array.is_a?(Array)
        instance_or_array.each { |item| update(item) }
      else

        @@objs << instance_or_array.object_id

        update_hash = {}
        update_hash[instance_or_array.class.to_s] = instance_or_array.instance_variables.map do |ivar|
          ivar.to_s
        end
        update_hash.delete_if { |klass, attrs| attrs.empty? }
        self.add(update_hash)
        update_references(instance_or_array)
      end
    end

    def self.update_references(instance)
      instance.instance_variables.each do |prop|
        value = instance.send(reader_sig_for(prop))
        next if @@objs.include?(value.object_id)
        update(value)
      end
    end

    def self.attributesForClass(klass)
      self.cache[klass.to_s]
    end

    def self.clear_cache
      NSUserDefaults.standardUserDefaults[CACHE_KEY] = nil
    end

    def self.classes
      self.cache.keys.map { |klass_name| Object.const_get(klass_name) }
    end

    private

    def self.setCache(new_cache)
      NSUserDefaults.standardUserDefaults[CACHE_KEY] = new_cache
    end

    def self.add(to_add)
      updated = self.cache.mutableCopy.merge!(to_add) { |key, orig_val, new_val|
        orig_val | new_val
      }
      setCache(updated)
    end

  end
end