describe "Cache" do

  before do
    Turnkey::Cache.clear_cache
    @dummy_cache_hash = {'Song' => ['@title', '@artist']}
  end

  it "returns cache from NSUserDefaults or empty hash" do
    Turnkey::Cache.cache.class.should == Hash
    Turnkey::Cache.cache.empty?.should == true
    NSUserDefaults.standardUserDefaults[Turnkey::Cache::CACHE_KEY] = @dummy_cache_hash
    Turnkey::Cache.cache.should == @dummy_cache_hash
  end

  describe "writing and reading" do

    before do
      Turnkey::Cache.setCache(@dummy_cache_hash)
    end

    it "can add key/value pairs to the cache" do
      Turnkey::Cache.add({'Artist' => ['@name']})
      Turnkey::Cache.cache.should == {
        'Song' => [
          '@title',
          '@artist'
        ],
        'Artist' => [
          '@name'
        ]
      }
    end

    it "only adds unique values for duplicate keys" do
      Turnkey::Cache.add({'Artist' => ['@name']})
      Turnkey::Cache.add({'Artist' => ['@name', '@record_label']})
      Turnkey::Cache.cache['Artist'].should == ['@name', '@record_label']
    end

    it "#update accepts an instance" do
      Turnkey::Cache.setCache({})
      song = Song.new.tap { |s| s.title = "In Bloom" }
      Turnkey::Cache.update(song)
      Turnkey::Cache.cache.should == {"Song" => ["@title"]}
    end

    it "#update recursively applies to an instances references" do
      Turnkey::Cache.clear_cache
      Turnkey::Cache.cache.empty?.should == true
      class Artist;attr_accessor :name;end
      artist = Artist.new.tap{|a| a.name = "Nirvana"}
      song = Song.new.tap{|s| s.title = "In Bloom";s.artist = artist}
      Turnkey::Cache.update(song)
      Turnkey::Cache.cache.should == {"Song" => ["@title","@artist"], "Artist" => ["@name"]}
    end

    it "#update accepts an array or a single instance" do
      Turnkey::Cache.clear_cache
      Turnkey::Cache.cache.empty?.should == true
      songs_array = 5.times.map{Song.new.tap{|s| s.title = "In Bloom"}}
      Turnkey::Cache.update(songs_array)
      Turnkey::Cache.cache.should == {"Song" => ["@title"]}
    end

    it "accepts a class and returns it's list of attributes" do
      Turnkey::Cache.attributesForClass(Song).should == ["@title", "@artist"]
    end

    it "#classes returns an array of classes" do
      class Artist;end
      Turnkey::Cache.add({'Artist' => ['@name']})
      klasses = Turnkey::Cache.classes
      klasses.should == [Song, Artist]
      klasses.each do |klass|
        klass.class.should == Class
      end
    end
  end
end