require 'sinatra'
require 'erb'

=begin
    
     Univesidad de la laguna
     Sistemas y Tecnologias Web
     Autor: Hamilton Steven Cubillos - alu3958
     Objetivo: Aplicacion web del juego piedra,papel o tijera.   
   
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


get '/throw' do
   erb :index   
end

=begin
    descripcion del siguiente bloque: Tolerancia de la cadena vacia.
=end

get '/throw/' do
   redirect '/'
end

=begin
  Cualquier ruta que no coincida con las de la aplicacion se redigiran a la raiz
=end

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
    @answer = "Empate"
    @images = image_throw @player_throw


  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer wins #{@computer_throw.capitalize} defeat to #{@player_throw.capitalize}"
    @images = image_throw @computer_throw
  else
    @answer = "Well done #{@player_throw.capitalize} beats #{@computer_throw.capitalize}"
    @images = image_throw @player_throw
  end
  
  erb :myTemplate, :layout => :mylayout
end

