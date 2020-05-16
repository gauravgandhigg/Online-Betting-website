require  'sinatra'

get '/form' do
    
end
get '/hello' do
    "<h1>hello,bantai</h1>"
end
post '/login' do
    username=params[:username]
    password=params[:password]
    
end