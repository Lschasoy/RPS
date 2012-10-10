require 'sinatra'
require 'haml'

=begin
    
     Univesidad de la laguna
     Asig: Sistema y tecnologia web
     Autor: Leonardo Siverio - alu3270
     Name : Simpson Rock, paper and scissor.
     descrip: Uso del sintra para el desarrollo de un juego RPS, con Haml    
   
=end



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
   haml :form
end


=begin 
   name: Lanzar el Juego
   Description: 
=end


get '/throw' do
   haml :index   
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
  session[:score_computer] ||= 0
  session[:score_player] ||=  0
 
   
  redirect '/'  unless @throws.include? @player_throw.downcase

  @computer_throw = @throws.sample
  @images_computer = image_throw @computer_throw


  if @player_throw == @computer_throw
    @answer = "Empate"
    @images = image_throw @player_throw

    session[:score_computer] += 1
    session[:score_player] +=  1

  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Pc Ganas #{@computer_throw} defeats to #{@player_throw}"
    @images = "/images/Pierdes.jpg"

    session[:score_computer] += 1

  else
    @answer = "Bien Hecho, Tu Ganas. #{@player_throw.capitalize} beats #{@computer_throw}"
    @images = image_throw @player_throw

    session[:score_player] += 1

  end
  
  haml :myTemplate, :layout => :mylayout
end
