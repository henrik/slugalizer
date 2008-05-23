Slugalizer is a one-method Ruby library that can slugalize (or slugify) strings, like this:

    Slugalizer.slugalize("Åh, räksmörgåsar!")
    # => "ah-raksmorgasar"
  
`iconv`-based solutions are usually [inconsistent between platforms](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/243426). Slugalizer achieves consistency by using the [`unicode` library](http://www.yoshidam.net/Ruby.html).

You can install that library with `gem install unicode`.

[Originally]((http://termos.vemod.net/slugalizer) by [Christoffer Sawicki](http://termos.vemod.net/).

Modified by [Henrik Nyh](http://henrik.nyh.se/).

Released into the public domain.
