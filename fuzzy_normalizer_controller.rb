require 'rubygems'
require 'sinatra'
require 'active_support'
require 'fuzzy_normalizer'
require 'haml'

#set :environment, :development
#set :show_exceptions, false

class FuzzyNormalizerController
 
  get '/doc' do
    haml :doc
  end
  
  post '/regularize_fuzzy' do
    normalizer = FuzzyNormalizer.new
    json = ActiveSupport::JSON.decode(request.body.read)
    json["witnesses"].each do |witness|
      normalizer.addTokens witness["tokens"]
    end
    translation_table = normalizer.translation_table
    json["witnesses"].each { |witness| normalizer.translate( witness ) }
    ActiveSupport::JSON.encode json
  end
  
end