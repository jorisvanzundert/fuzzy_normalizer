require 'fuzzy_normalizer.rb'
require 'test/unit'

class FuzzyNormalizerTest < Test::Unit::TestCase

  def test_maximizes_normalization
    # hallo => gallo, callo
    # tallo => callo, lallo, hallo
    # gallo => mallo
    # Results in:  
    # callo => tallo
    # lallo => tallo
    # hallo => tallo
    # gallo => hallo
    # mallo => gallo  --> willen we dit
  end
  
  def test_add_text
    # compare text in translationtable out
  end

  def test_add_tokens
    # compare token hash in translationtable out
  end

end