describe "Archiver" do

  describe "#define_protocols" do
    it "should define nskeyedunarchiver protocols on model instance" do
      song = Song.new(title: "In Bloom", album: "Nevermind", artist: "Nirvana")
      song.respond_to?(:initWithCoder).should == false
      Turnkey::Archiver.define_protocols(song)
      song.respond_to?(:initWithCoder).should == true
    end

  end
end