require 'sinatra/reloader'
require 'sinatra'
require './login'

configure do
    enable :sessions
    set :username,"scout"
    set :password,"scout"
end

def lost_session(won_lost, money)
    count = (session[won_lost] || 0).to_i
    count += money
    session[won_lost] = count
    session[:total]-=money
end

def won_session(won_lost, money)
    count = (session[won_lost] || 0).to_i
    count += money*10
    session[won_lost] = count
    session[:total]+=money*10
end

get '/'do
   erb :auth 
end

get '/home' do
    
    erb :auth
end

get '/auth' do
    if session[:login] 
        erb :bet365
    else
        erb :auth
    end
end

post '/auth' do
    user=Login_info.first(:username=> params[:username])
    if user!=nil && user.password==params[:password]
        session[:valid]=true
        session[:total]=0
        session[:win]=0
        session[:lost]=0
        session[:id]=user.id
        session[:ftotal]=user.total
        session[:fwon]=user.won
        session[:flost]=user.won-user.total
        session[:message]="Welcome #{params[:username]}"
        erb :bet365
    else
        session[:valid]=false
        redirect '/auth'
    end      
end

get '/bet' do
    stake = params[:stake].to_i
    number = params[:number].to_i
    roll = rand(6) + 1
    if number == roll 
        won_session(:win, stake) 
        session[:result]="The dice landed on #{roll}, you win #{10*stake} dollars !"
        erb :bet365
    else
        lost_session(:lost, stake)
        session[:result]="The dice landed on #{roll}, you lost #{stake} dollars !"
        erb :bet365
    end
end
  
get '/bet365' do
    erb :bet365
end

get '/signup' do
    erb :signup
end

post '/signup' do
    user=Login_info.first(:username=> params[:username])
    if user!=nil
        session[:signup]="Username already taken :/"
        erb :signup
    else
    n_user= Login_info.create(username: params[:username],password: params[:password], total: 0, won: 0)
    session[:signup]="You've signed up! Please Login to continue."
    erb :auth
    end
end

get '/logout' do
    session[:ftotal]+=session[:total]
    session[:fwon]+=session[:win]
    user=Login_info.get(session[:id])
    user.update(:total=> session[:ftotal],:won=> session[:fwon])


    session[:ftotal]=nil
    session[:fwon]=nil
    session[:id]=nil
    session[:total]=nil
    session[:win]=nil
    session[:lost]=nil
    session[:valid]=nil
    session[:message]="You're Logged Out"
    erb :auth
    
end