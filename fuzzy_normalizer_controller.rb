require 'rubygems'
require 'sinatra'
require 'active_support'
require 'fuzzy_normalizer'

#set :environment, :development
#set :show_exceptions, false

class FuzzyNormalizerController
 
  get '/doc' do
    "accepts: JSON formatted CollateX token sets adhering to http:\/\/gregor.middell.net\/collatex\/api\/collate\r\n
    returns: fuzzy regularized JSON fromatted CollateX token sets" 
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