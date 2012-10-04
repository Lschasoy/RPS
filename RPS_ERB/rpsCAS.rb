require 'sinatra'
require 'erb'

=begin
    
     Univesidad de la laguna
     Asig: Sistema y tecnologia web
     Autor: Leonardo Siverio - alu3270
     Name : Simpson Rock, paper and scissor.
     descrip: Uso del sintra para el desarrollo de un juego RPS    
   
=end


def image_throw ima_t
  "/images/#{ima_t.downcase}.jpg"
end

set :public_forder, File.dirname(__FILE__)


before do
  @defeat = { rock: :scissors, paper: :rock, scissors: :paper}
  @throws = @defeat.keys

end

get '/' do
   erb :form, :layout => :mylayout
end


=begin 
   name: Lanzar el Juego
   Description: 
=end


get '/throw' do
   erb :index   
end

=begin
    descrip: Si le paso la cadena vacia
=end

get '/throw/' do
   redirect '/'
end

get %r{^(?!/throw/)} do
   redirect '/'
end


get '/throw/:player_throw' do
  # the params hash stores querystring and form data
   
  @player_throw = (params[:player_throw]||'').to_sym
  @images_player = image_throw @player_throw
    

  redirect '/'  unless @throws.include? @player_throw.downcase

  @computer_throw = @throws.sample
  @images_computer = image_throw @computer_throw


  if @player_throw == @computer_throw
    @answer = "Tie"
    @images = image_throw @player_throw


  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer Wins; #{@computer_throw} defeats to #{@player_throw}"
    @images = "/images/Pierdes.jpg"
  else
    @answer = "Well done. #{@player_throw.capitalize} beats #{@computer_throw}"
    @images = image_throw @player_throw

  end
  
  erb :myTemplate, :layout => :mylayout
end