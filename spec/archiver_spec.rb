describe "Archiver" do

  describe "Archiver#archive" do

    it "should include nscoder protocols on referenced objects if necessary" do
      class Dummy;attr_accessor :foo, :ref;end
      class OtherDummy;attr_accessor :baz;end
      other = OtherDummy.new.tap{|o| o.baz = "baz"}
      dummy = Dummy.new.tap{|d| d.foo = "foo"; d.ref = other}
      other.respondsToSelector("encodeWithCoder:").should == false
      other.respondsToSelector("initWithCoder:").should == false
      Turnkey::Archiver.archive(dummy, "dummy-archive")
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
      Turnkey::Archiver.archive(dummy2, "dummy2-archive")
      ref1.respondsToSelector("encodeWithCoder:").should == true
      ref1.respondsToSelector("initWithCoder:").should == true
      ref2.respondsToSelector("encodeWithCoder:").should == true
      ref2.respondsToSelector("initWithCoder:").should == true
    end

    #it "should save the encoded object to NSUserDefaults under provided key" do
    #  Turnkey::Archiver.archive(@song, "nirvana_song")
    #  NSUserDefaults.standardUserDefaults["nirvana_song"].should != nil
    #end
  end
end