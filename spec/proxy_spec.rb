describe "Proxy" do

  describe "caching ivars in class variable" do

    it "should only add unique values to @@vars array" do
      Song.class_eval { include(Turnkey::Proxy) }
      @song1 = Song.new.tap { |s| s.title = "In Bloom"; s.album = "Nevermind" }
      NSKeyedArchiver.archivedDataWithRootObject(@song1)
      @song2 = Song.new.tap { |s| s.title = "Lounge Act"; s.album = "Nevermind"; s.artist = "Nirvana"}
      NSKeyedArchiver.archivedDataWithRootObject(@song2)
      p Song.tk_vars.inspect
      Song.tk_vars.length.should == 3
    end
  end
end