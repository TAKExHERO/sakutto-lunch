require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rest_client'

get '/' do
  'hello world!!'
end

get '/callback' do
  if params["hub.verify_token"] != 'hogehoge'
    return 'Error, wrong validation token'
  end
  params["hub.challenge"]
end

post '/callback' do
  hash = JSON.parse(request.body.read)
  message = hash["entry"][0]["messaging"][0] #entryの0個目のmessagingの0個目
  sender = message["sender"]["id"] #上記で取得したmessage変数の中のsenderのid
  text = message["message"]["text"]#上記で取得したmessage変数の中のmessageのtest
  endpoint = "https://graph.facebook.com/v2.6/me/messages?access_token=" + "EAAfqufUBZC5gBAJ7NZAC0uhXhwXwY56WaFNqR9ea4z2RDNoPxZAA6mq8vzoVbWqaGSKIgMH8EUnpMpNbKlg1GFOEhzPZBZAZBEZCB0dq7R5bjVNKpSAULZAJkZAvzANksCB5Klyp1bZACHm5nnlpLclfj8GX5Ry1jYg4ODAcbiznlFDlT7ZBAnu06ZBd"
  content = {
    recipient: {id: sender},
    message: {text: text}
  }
  request_body = content.to_json

  #オウム返しの返信をPOSTする（返す）
  RestClient.post endpoint, request_body, content_type: :json, accept: :json
  status 201
  body ''
end
