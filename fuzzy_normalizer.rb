require 'rubygems'
require 'active_support'
require 'levenshtein'
require 'set'

class FuzzyNormalizer

  def initialize
    @vocabulary = Hash.new
  end
  
  def translation_table
    @translation_table = build_translation_table if @translation_table.nil?
    @translation_table
  end
  
  # Rational
  # Some tentative testing showed that combined vocabualry increases
  # only in ever smaller amounts with any new text, so fuzzy matching/normalizing
  # the vocabulary is always more efficient than normalizing all text.
  # Certainly when we're using variant texts (so text comparatively similar). 

  def addText( text ) 
    text.split.each { |token| @vocabulary[token.downcase] = [] } 
  end

  def addTokens( tokens )
    tokens.each { |token| @vocabulary[token["t"].downcase] = [] } 
  end

  def build_translation_table  
    @vocabulary.each do |token_type, fuzzy_matches|
      @vocabulary.each_key do |vocabulary_entry|
        fuzzy_matches << vocabulary_entry if Levenshtein::normalized_distance( vocabulary_entry, token_type ) < 0.2
      end
    end
    @vocabulary = @vocabulary.sort { |a,b| a[1].size<=>b[1].size }
    translation_table = Hash.new
    # now we use fuzzy_matches.each as key for a new hash table translating key to vocabulary[0]
    # but not! if we have seen that fuzzy_match as key in the new hash table already
    # That's a maximized generalization approach (would be nice to have proof of this)
    # if we ignore the 'not! if', we get a minimalized generalization approach
    # Note: the resulting translation table holds many items A => A (identities)
    # but reducing is rahter pointless as table scans are straightforward and performance gain
    # would be minimal (and possibly undone by extra nil checks needed).
    @vocabulary.each do |vocabulary_entry|
      normalized_entry = vocabulary_entry[0]
      fuzzy_matches = vocabulary_entry[1]
      fuzzy_matches.each do |fuzzy_match|
        translation_table[fuzzy_match] = normalized_entry if !translation_table.has_key? fuzzy_match 
      end
    end
    translation_table
  end

  def translate( witness )
    translator = @translation_table
    witness["tokens"].each { |token| token["n"] = translator[token["t"].downcase ] }
  end

end