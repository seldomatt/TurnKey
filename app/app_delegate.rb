class AppDelegate

  def application(application, didFinishLaunchingWithOptions:options)
    # just create an instance of your custom object, set some properties (or not),
    # and use Turnkey#archive, passing the instance and the key you'd like to save it to
    # NSUserDefaults.standardUserDefaults (db) under
    song = Song.new.tap{|s| s.title = "In Bloom"; s.artist = "Nirvana"}
    p "Archiving song instance..."
    Turnkey.archive(song, "In Bloom")
    ## => returns true
    ##when you want to get this object out of the db, use Turnkey#unarchive, passing the key
    ##as an arg
    p "Unarchiving song instance..."
    #Turnkey#unarchive returns a new instance with identical properties to the archived instance
    fetched_song = Turnkey.unarchive("In Bloom")
    p "#{fetched_song.title} - by #{fetched_song.artist}"
    true
  end

end