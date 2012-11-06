require 'sinatra'
require 'syntaxi'

class String
  def formatted_body
    source = "[code lang='ruby']
                #{self}
              [/code]"
    html = Syntaxi.new(source).process
    %Q{
      <div class="syntax syntax_ruby">
        #{html}
      </div>
    }
  end
end

get '/' do
  erb :new
end

post '/' do
  .....
end
