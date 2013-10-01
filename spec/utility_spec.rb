describe "Utility" do

  before do
    class DummySong;attr_accessor :title, :album, :artist;end
    @song = DummySong.new.tap { |s|
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

  describe "define protocols on object's references" do

    it "should include nscoder protocols on referenced objects if necessary" do
      class Dummy;attr_accessor :foo, :ref;end
      class OtherDummy;attr_accessor :baz;end
      other = OtherDummy.new.tap{|o| o.baz = "baz"}
      dummy = Dummy.new.tap{|d| d.foo = "foo"; d.ref = other}
      other.respondsToSelector("encodeWithCoder:").should == false
      other.respondsToSelector("initWithCoder:").should == false
      Turnkey::Utility.extend_protocols_to_object_references(dummy)
      other.respondsToSelector("encodeWithCoder:").should == true
      other.respondsToSelector("initWithCoder:").should == true
    end

    it "should include nscoder protocols on multiple referenced objects if necessary" do
      class Dummy2;attr_accessor :ref, :other_ref;end
      class Ref;attr_accessor :foo;end
      class OtherRef;attr_accessor :bar;end
      ref1 = Ref.new.tap{|r| r.foo = "foo"}
      ref2 = OtherRef.new.tap{|rt| rt.bar = "bar"}
      ref1.respondsToSelector("encodeWithCoder:").should == false
      ref1.respondsToSelector("initWithCoder:").should == false
      ref2.respondsToSelector("encodeWithCoder:").should == false
      ref2.respondsToSelector("initWithCoder:").should == false
      dummy2 = Dummy2.new.tap{|d| d.ref = ref1;d.other_ref = ref2}
      Turnkey::Utility.extend_protocols_to_object_references(dummy2)
      ref1.respondsToSelector("encodeWithCoder:").should == true
      ref1.respondsToSelector("initWithCoder:").should == true
      ref2.respondsToSelector("encodeWithCoder:").should == true
      ref2.respondsToSelector("initWithCoder:").should == true
    end
  end
end