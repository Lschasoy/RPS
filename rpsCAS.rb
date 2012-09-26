require 'sinatra'
require 'erb'

set :public_forder, File.dirname(__FILE__)

before do
  @defeat = { rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys
end

get '/' do
   erb :form
end

get '/throw' do
   erb :index
end

def image_throw ima_t
  if ima_t == :rock
	images= "/images/rock.jpg"
  elsif ima_t == :scissors
	images= "/images/scissors.jpg"
  elsif ima_t == :paper
	images= "/images/paper.jpg"
  end
end

post '/throw' do
  # the params hash stores querystring and form data
   
  @player_throw = params[:player_throw].to_sym
  @images_player = image_throw @player_throw

  halt(403, "You must throw one of the following: '#{@throws.join(', ')}'") unless @throws.include? @player_throw

  @computer_throw = @throws.sample
  @images_computer = image_throw @computer_throw

  
  if @player_throw == @computer_throw 
    @answer = "Empatas"
    @images = image_throw @player_throw
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer Gana; #{@computer_throw} defeats #{@player_throw}"
    @images = image_throw @computer_throw
  else
    @answer = "Bien Hecho. #{@player_throw} ha ganado #{@computer_throw}"
    @images = image_throw @player_throw
  end
erb :myTemplate, :layout => :mylayout



end
