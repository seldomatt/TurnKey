describe "Archiver" do

  before do
    @song = Song.new.tap { |s|
      s.title = "In Bloom"
      s.album = "Nevermind"
      s.artist = "Nirvana"
    }
  end

  it "should define nskeyedunarchiver protocols on model instance" do
    @song.respond_to?(:encodeWithCoder).should == false
    Turnkey::Archiver.defineEncodeWithCoder(@song)
    @song.respond_to?(:encodeWithCoder).should == true
  end

  describe "Archiver#archive" do

    it "should save encoded object to NSUserDefaults under provided key" do
      Turnkey::Archiver.archive(@song, "nirvana_song")
      NSUserDefaults.standardUserDefaults["nirvana_song"].should != nil

    end

  end


  #it "#define_protocols should define both ns..archiver methods" do
  #  #had to make this dummy class as RM was behaving strangely when trying to #remove_method
  #  #or #undef_method from Song class in setup for this spec
  #  class NewClass; end
  #  new_instance = NewClass.new
  #  new_instance.respond_to?(:initWithCoder).should == false
  #  new_instance.respond_to?(:encodeWithCoder).should == false
  #  Turnkey::Archiver.define_protocols(new_instance)
  #  new_instance.respond_to?(:initWithCoder).should == true
  #  new_instance.respond_to?(:encodeWithCoder).should == true
  #end

end