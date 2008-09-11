#!/usr/bin/env ruby
#
# Slugalizer
# http://github.com/henrik/slugalizer

begin
  require "active_support/multibyte"
rescue LoadError
  require "rubygems"
  require "active_support/multibyte"
end


module Slugalizer
  extend self
  SEPARATORS = %w[- _ +]
  
  def slugalize(text, separator = "-")
    unless SEPARATORS.include?(separator)
      raise "Word separator must be one of #{SEPARATORS}"
    end
    re_separator = Regexp.escape(separator)
    ActiveSupport::Multibyte::Handlers::UTF8Handler.normalize(text.to_s, :kd).
      gsub(/[^\x00-\x7F]+/, '').                       # Remove anything non-ASCII entirely (e.g. diacritics).
      gsub(/[^a-z0-9\-_\+]+/i, separator).             # Turn non-slug chars into the separator.
      squeeze(separator).                              # No more than one of the separator in a row.
      gsub(/^#{re_separator}|#{re_separator}$/i, '').  # Remove leading/trailing separator.
      downcase
  end
end


if __FILE__ == $0
  require "test/unit"
  
  class SlugalizerTest < Test::Unit::TestCase
    def assert_slug(expected_slug, *args)
      assert_equal(expected_slug, Slugalizer.slugalize(*args))
    end
    
    def test_converting_to_string
      assert_slug("", nil)
      assert_slug("1", 1)
    end
    
    def test_identity
      assert_slug("abc-1_2_3", "abc-1_2_3")
    end
    
    def test_asciification
      assert_slug("raksmorgas", "räksmörgås")
    end
    
    def test_downcasing
      assert_slug("raksmorgas", "RÄKSMÖRGÅS")
    end
    
    def test_special_characters_outside
      assert_slug("raksmorgas", " räksmörgås!?.")
    end
    
    def test_special_characters_inside
      assert_slug("raka-smorgas-nu", "räka@smörgås.nu")
    end
    
    def test_no_leading_or_trailing_separator
      assert_slug("i-love-c++", "I love C++")
      assert_slug("i-love-c", "I love C--")
    end
    
    def test_accented_characters
      assert_slug("acegiklnuo", "āčēģīķļņūö")
    end
    
    def test_chinese_text
      assert_slug("chinese-text", "chinese 中文測試 text")
    end
    
    def test_stripped_character_then_whitespace
      assert_slug("abc", "! abc !")
    end
      
    def test_single_whitescape
      assert_slug("smorgasbord-e-gott", "smörgåsbord é gott")
    end
    
    def test_surrounding_whitescape
      assert_slug("smorgasbord-e-gott", " smörgåsbord é gott ")
    end
    
    def test_excessive_whitescape
      assert_slug("smorgasbord-ar-gott", "smörgåsbord  \n  är  \t   gott")
    end
    
    def test_squeeze_separators
      assert_slug("a-b", "a - b")
      assert_slug("a-b", "a--b")
    end
    
    def test_separator_parameter
      assert_slug("smorgasbord-ar-gott", "smörgåsbord är gott", "-")
      assert_slug("smorgasbord_ar_gott", "smörgåsbord är gott", "_")
      assert_slug("smorgasbord+ar+gott", "smörgåsbord är gott", "+")
    end
    
    def test_invalid_separator
      assert_raise(RuntimeError) do
        Slugalizer.slugalize("smörgåsbord är gott", "@")
      end
    end
    
    def test_handling_of_separator_chars
      assert_slug("abc_-_1_2_3", "abc - 1_2_3", "_")
    end
    
    def test_handling_of_stuff
      assert_slug("foo-+-b_a_r", "foo + b_a_r")
    end
    
    def test_with_kcode_set_to_utf_8
      old_kcode = $KCODE
      $KCODE = "u"
      assert_slug("raksmorgas", "räksmörgås")
    ensure
      $KCODE = old_kcode
    end

  end
end
