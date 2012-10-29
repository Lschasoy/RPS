require 'sinatra'
require 'erb'

def image_throw ima_t
  "/images/#{ima_t.downcase}.jpg"
end

set :public_forder, File.dirname(__FILE__)

enable :sessions

before do
  @defeat = { rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
end

get '/' do
	if session[:marcador_player].nil?
		session[:marcador_player] = session[:marcador_pc] = 0
	end
   erb :form, :layout => :mylayout
end

get '/throw' do
   erb :index
end

get '/throw/' do #redirecciona si la jugada es vacia
   redirect '/'
end

get '/throw/:player_throw' do
  # the params hash stores querystring and form data
   
  puts params
  @player_throw = (params[:player_throw]||'').to_sym
  @images_player = image_throw @player_throw

  redirect'/' unless @throws.include? @player_throw.downcase

  @computer_throw = @throws.sample
  @images_computer = image_throw @computer_throw

  if @player_throw == @computer_throw
    @answer = "Tie"
    @images = image_throw @player_throw
     
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer Wins; #{@computer_throw} defeats to #{@player_throw}"
    @images = "/images/Pierdes.jpg"
    session[ :marcador_pc ] += 1
  else
    @answer = "Well done. #{@player_throw.capitalize} beats #{@computer_throw}"
    @images = image_throw @player_throw
    session[ :marcador_player ] += 1 
  end
  
  erb :myTemplate, :layout => :mylayout
end
