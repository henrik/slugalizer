Slugalizer is a one-method Ruby library that can slugalize (or slugify) strings, like this:

    Slugalizer.slugalize("Åh, räksmörgåsar!")
    # => "ah-raksmorgasar"
    
Defaults to the "-" word separator but can also use "+" or "_":

    Slugalizer.slugalize("Åh, räksmörgåsar!", "+")
    # => "ah+raksmorgasar"
    
    Slugalizer.slugalize("Åh, räksmörgåsar!", "_")
    # => "ah_raksmorgasar"
    
Uses the the [`unicode` library](http://www.yoshidam.net/Ruby.html) (`gem install unicode`) if available.

Falls back to `iconv` from the Ruby standard library if `unicode` can't be loaded, but note that this library is [inconsistent between platforms](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/243426).

[Originally]((http://termos.vemod.net/slugalizer) by [Christoffer Sawicki](http://termos.vemod.net/).

Modified by [Henrik Nyh](http://henrik.nyh.se/).

Released into the public domain.
