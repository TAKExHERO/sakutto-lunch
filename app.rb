equire 'sinatra'
require 'sinatra/reloader'

get '/' do
  'hello world!!'
end

# 以下を追記します

get '/callback' do
  if params["hub.verify_token"] != 'hogehoge'
    return 'Error, wrong validation token'
  end
  params["hub.challenge"]
end
