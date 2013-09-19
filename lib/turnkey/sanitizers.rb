module Turnkey

  module Sanitizers

    def reader_sig_for(property)
      property.to_s.delete("@")
    end

    def writer_sig_for(property)
      property.to_s.delete("@") + "="
    end

  end

end