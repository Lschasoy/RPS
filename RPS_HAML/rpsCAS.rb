require 'sinatra'
require 'haml'
require 'openssl'


def image_throw ima_t
  "/images/#{ima_t}.jpg"
end

set :public_forder, File.dirname(__FILE__)

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
	haml :form, :layout => :mylayout
end

get '/throw' do
   haml :index
end

get '/throw/' do
	redirect '/'
end

get %r{[^/throw/(scissors|rock|paper)]} do
   redirect '/'
end

get %r{/throw\w+} do
	redirect '/'
end

post '/reset' do
	session.clear
	redirect '/'
end


get '/throw/:player_throw' do
  # the params hash stores querystring and form data
   
  puts params
  @player_throw = (params[:player_throw]||'').to_sym
  @images_player = image_throw @player_throw

  redirect '/' unless @throws.include? @player_throw.downcase

  @computer_throw = @throws.sample
  @images_computer = image_throw @computer_throw

  if @player_throw == @computer_throw
    @answer = "Tie"
    @images = image_throw @player_throw
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer Wins; #{@computer_throw} defeats to #{@player_throw}"
	 session[:computer_score]+=1
    @images = image_throw @computer_throw
  else
    @answer = "Well done. #{@player_throw.capitalize} beats #{@computer_throw}"
	 session[:player_score]+=1
    @images = image_throw @player_throw
  end
  haml :myTemplate, :layout => :mylayout
end
