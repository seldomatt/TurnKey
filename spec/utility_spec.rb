describe "Utility" do

  before do
    @song = Song.new.tap { |s|
      s.title = "In Bloom"
      s.album = "Nevermind"
      s.artist = "Nirvana"
    }
  end

  it "should define nskeyedunarchiver and nskeyedarchiver protocols on model instance" do
    @song.respondsToSelector("encodeWithCoder:").should == false
    @song.respondsToSelector("initWithCoder:").should == false
    Turnkey::Utility.defineProtocols(@song)
    @song.respondsToSelector("encodeWithCoder:").should == true
    @song.respondsToSelector("initWithCoder:").should == true
  end

  describe "call #defineProtocols on class with protocols already implemented" do

    before do
      class Implemented
        attr_accessor :foo, :bar

        def encodeWithCoder(coder)

        end

        def initWithCoder(decoder)

        end
      end

      class NotImplemented
        attr_accessor :foo, :bar

      end
      @implemented = Implemented.new.tap {|i| i.foo = "foo"; i.bar = "bar"}
      @not_implemented = NotImplemented.new.tap {|i| i.foo = "foo"; i.bar = "bar"}
    end

    it "should not extend protocols to instance's class if already been extended" do
      Turnkey::Utility.defineProtocols(@implemented)
      write_data = NSKeyedArchiver.archivedDataWithRootObject(@implemented)
      NSUserDefaults.standardUserDefaults["implemented"] = write_data
      read_data = NSUserDefaults.standardUserDefaults["implemented"]
      read_implemented = NSKeyedUnarchiver.unarchiveObjectWithData(read_data)
      read_implemented.should == nil
    end

    it "should extend protocols to instance's class that has not already been extended" do
      Turnkey::Utility.defineProtocols(@not_implemented)
      write_data = NSKeyedArchiver.archivedDataWithRootObject(@not_implemented)
      NSUserDefaults.standardUserDefaults["not_implemented"] = write_data
      read_data = NSUserDefaults.standardUserDefaults["not_implemented"]
      read_not_implemented = NSKeyedUnarchiver.unarchiveObjectWithData(read_data)
      read_not_implemented.foo.should == "foo"
    end
  end
end