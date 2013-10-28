![Turnkey](/tk-logo.png)

turnkey
=======

a rubymotion utility for extending [NSCoder protocols](https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/Protocols/NSCoding_Protocol/Reference/Reference.html) and saving objects to [NSUserDefaults](https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSUserDefaults_Class/Reference/Reference.html)

### Installation

```bash
$ gem install turnkey
```

### Setup

Add this line to your Rakefile:

```ruby
require 'turnkey'
```

or, if you're using Bundler, to your Gemfile:

```ruby
gem 'turnkey'
```

### Usage
####Saving objects to defaults

To save a custom object to defaults, just pass the object, along with the key you'll use to retrieve it, to Turnkey's `archive` method:

```ruby
song = Song.new.tap{|s| s.title = "In Bloom"; s.artist = "Nirvana"}
=> #<Song:0x82b4ef0 @title="In Bloom" @artist="Nirvana">
Turnkey.archive(song, "Nirvana Song")
=> true
```
To retrieve it, call `unarchive`

```ruby
Turnkey.unarchive("Nirvana Song")
=> #<Song:0x84b8ab0 @title="In Bloom" @artist="Nirvana">
```
####Arrays/Hashes

You can also pass Arrays or Hashes of objects to `archive`:

#####Array

```ruby
song_array = []
=> []
5.times {|i| song_array << Song.new.tap{|s| s.title = "Song ##{i + 1}"}}
=> 5

Turnkey.archive(song_array, "List of Songs")
=> true

Turnkey.unarchive("List of Songs")
=> [#<Song:0x8445090 @title="Song #1">, #<Song:0x8441dd0 @title="Song #2">, #<Song:0x8442110 @title="Song #3">, #<Song:0x8442450 @title="Song #4">, #<Song:0x8442820 @title="Song #5">]
```
#####Hash
```ruby
hash = {songs: song_array, song: Song.new.tap{|s| s.title = "7 and 7 Is"}}
Turnkey.archive(hash, "Song Dictionary")
=> true
Turnkey.unarchive("Song Dictionary")
=> {"songs"=>[#<Song:0x76bdd30 @title="Song #1">, #<Song:0x76be260 @title="Song #2">, #<Song:0x76be5a0 @title="Song #3">, #<Song:0x76be920 @title="Song #4">, #<Song:0x76bec60 @title="Song #5">], "song"=>#<Song:0x76bf000 @title="7 and 7 Is">}
```

####Relations
Turnkey's `archive` can take objects with references to other custom objects, i.e
```ruby
a = Artist.new.tap{|artist| artist.name = "Stone Roses"}
s = Song.new{|song| song.title = "Made of Stone"; song.artist = a}
Turnkey.archive(song, "song with artist")
```
The NSCoder Protocols will be extended to both the object being archived and any objects it holds references to ; )

Rock.

