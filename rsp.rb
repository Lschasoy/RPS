before do
   content_type :txt
   @defeat = {:rock => paper,:paper => scissors,:scissors => rock}
   @throws= @defeat.keys
end
require  'sinatra'
get '/throw/type' do
    player_throw = params[type].to_sym
    halt 403, "tu debes intentar algunas de las siguientes opciones:  #{@throws}"
    unless @throws.include? player.throw

   computer_throw = @throws.sample
    if player_throw == computer_throw 
          @answer="Haz perdido con la maquina,intenta de nuevo"
       elsif computer_throw == @defeat[player_throw] 
          @answer= "Tu ganas"
       else @answer="Maquina  gana"
     end
   erb:index
end

__END__
@@index
<html> 
   <body>
     <h1> <%= @answer %> </h1>
   </body>
</html>
