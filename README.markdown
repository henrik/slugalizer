Slugalizer is a one-method Ruby library that can slugalize (or slugify) strings, like this:

    Slugalizer.slugalize("Åh, räksmörgåsar!")
    # => "ah-raksmorgasar"
  
`iconv`-based solutions are usually inconsistent between platforms. Slugalizer achieves consistency by using the [`unicode` library](http://www.yoshidam.net/Ruby.html).

You can install that library with `gem install unicode`.

Originally [by Christoffer Sawicki](http://termos.vemod.net/slugalizer).

Released into the public domain.
