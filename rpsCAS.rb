require 'sinatra'
require 'erb'

# before we process a route we'll set the response as plain text
# and set up an array of viable moves that a player (and the
# computer) can perform
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
post '/throw' do
  # the params hash stores querystring and form data
   
  @player_throw = params[:player_throw].to_sym

  halt(403, "You must throw one of the following: '#{@throws.join(', ')}'") unless @throws.include? @player_throw

  @computer_throw = @throws.sample

  if @player_throw == @computer_throw 
    @answer = "Empatas"
    erb :index
  elsif @player_throw == @defeat[@computer_throw]
    @answer = "Computer Gana; #{@computer_throw} defeats #{@player_throw}"
    erb :index
  else
    @answer = "Bien Hecho. #{@player_throw} ha ganado #{@computer_throw}"
    erb :index
  end
end
__END__

@@index
<html>
  <head>
    <title>Rock Paper Scissors</title>
  </head>
  <body>
    <h2> Computer chooses:  <%= @computer_throw %> </h2>
    <h2> You choose: <%= @player_throw %> </h2>
    <h1> <%= @answer %> </h1>
  </body>
</html>
