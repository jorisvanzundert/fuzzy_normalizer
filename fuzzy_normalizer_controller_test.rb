require 'fuzzy_normalizer_controller.rb'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class FuzzyNormalizerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_doc
    get '/doc'
    assert last_response.ok?
    assert last_response.body =~ /accepts:(.*)/
  end

  def test_simple_post
    post '/regularize_fuzzy', 
      '{"witnesses" : [
            {"id" : "A", "tokens" : [
                    { "t" : "A" },
                    { "t" : "black" },
                    { "t" : "cat" }
                    ]}, 
            {"id" : "B", "tokens" : [
                    { "t" : "A" },
                    { "t" : "white" },
                    { "t" : "kitten.", "n" : "cat" }
                    ]}
            ]}'
    assert last_response.ok?
    assert last_response.body.include?( '{"n":"a","t":"A"}' )
    assert last_response.body.include?( '{"n":"black","t":"black"}' )
    assert last_response.body.include?( '{"n":"cat","t":"cat"}' )
    assert last_response.body.include?( '"id":"A"' )
    assert last_response.body.include?( '{"n":"a","t":"A"}' )
    assert last_response.body.include?( '{"n":"white","t":"white"}' )
    assert last_response.body.include?( '{"n":"kitten.","t":"kitten."}' )
    assert last_response.body.include?( '"id":"A"' )
  end
  
  def test_not_json
    post '/regularize_fuzzy', 
      '{"witnesses" : [
            {"id" : "A", "tokens" : [
                    { "t" : "A" },
                    { "t" : "black" },'
              puts last_response.body
  end
  
end