#!/usr/bin/env ruby
#
# Slugalizer
# http://github.com/henrik/slugalizer

require "rubygems"
require "unicode"

module Slugalizer
  extend self
  
  # Supported word separators: - _ +
  def slugalize(text, word_separator = "-")
    Unicode.normalize_KD(text).
      strip.
      gsub(/[^\w\s\-\+]/n, "").
      gsub(/\s+/, word_separator).
      downcase
  end
end

if __FILE__ == $0
  require "test/unit"
  
  class SlugalizerTest < Test::Unit::TestCase
    def assert_slug(expected_slug, *args)
      assert_equal(expected_slug, Slugalizer.slugalize(*args))
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
    
    def test_special_characters
      assert_slug("raksmorgas", "räksmörgås!?")
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
    
    def test_word_separator_parameter
      assert_slug("smorgasbord-ar-gott", "smörgåsbord är gott", "-")
      assert_slug("smorgasbord_ar_gott", "smörgåsbord är gott", "_")
      assert_slug("smorgasbord+ar+gott", "smörgåsbord är gott", "+")
    end
    
    def test_handling_of_word_separator_chars
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