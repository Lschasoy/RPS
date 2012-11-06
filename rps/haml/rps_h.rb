require 'sinatra'
require 'haml'

# before we process a route we'll set the response as plain text
# and set up an array of viable moves that a player (and the
# computer) can perform

set :public_folder, File.dirname(__FILE__)

before do
  @defeat = { rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
  
end

configure do
  enable :sessions
end

get '/' do
  if session[:player_score].nil?
    session[:player_score]=0
  end
  if session[:computer_score].nil?
    session[:computer_score]=0
  end

  haml :index
end

get %r{^(?!/throw/)} do
   redirect '/'
end

post '/reset' do
  session.clear
  redirect '/'
end

post '/again' do
  redirect '/'
end

post '/move' do
  @option = params[:select]
  redirect "/throw/#{@option}"
end
  
get '/throw/:type' do
  # the params hash stores querystring and form data
  @player_throw = params[:type].to_sym
   
  halt(403, "You must throw one of the following: '#{@throws.join(', ')}'") unless @throws.include? @player_throw

#   redirect '/' unless @throws.include? @player_throw
  
  @computer_throw = @throws.sample

  if @player_throw == @computer_throw
    @answer = "There is a tie"

  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer wins; #{@computer_throw} defeats #{@player_throw}"
    session[:computer_score]+=1
  else
    @answer = "Well done. #{@player_throw} beats #{@computer_throw}"
    session[:player_score]+=1

  end
  
  haml :final
  
end
