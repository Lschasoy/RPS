require 'sinatra'
require 'haml'

# before we process a route we'll set the response as plain text
# and set up an array of viable moves that a player (and the
# computer) can perform

configure do
  enable :sessions
end


before do
  @defeat = { rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
end





get '/' do
	if session[:MyScore].nil? 
	   session[:MyScore] = 0
	end
	if session[:ComputerScore].nil? 
	   session[:ComputerScore] = 0
	end
	haml :index
end


get '/logout' do
  session.clear
  redirect '/'
end

post '/play' do
	@option = params[:select]
	redirect "/throw/#{@option}"
end





get '/throw/:type' do
  # the params hash stores querystring and form data
  @player_throw = params[:type].to_sym

  halt(403, "You must throw one of the following: '#{@throws.join(', ')}'") unless @throws.include? @player_throw

  @computer_throw = @throws.sample

  if @player_throw == @computer_throw 
    @answer = "There is a tie."
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer wins, #{@computer_throw} defeats #{@player_throw}."
	 session[:ComputerScore]+=1
  else
    @answer = "You Win, #{@player_throw} beats #{@computer_throw}."
	 session[:MyScore]+=1
  end
	haml :champion
end



get '/*' do
	redirect '/'
end


