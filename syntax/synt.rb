require 'sinatra'
require 'syntaxi'

class String
  def formatted_body(lang)
    source = "[code lang='#{lang}']
                #{self}
              [/code]"
    html = Syntaxi.new(source).process
    %Q{
      <div class="syntax">
        #{html}
      </div>
    }
  end
end

get '/' do
  erb :new
end

post '/final' do
  @language=params[:select]
  @text=params[:body].formatted_body(@language)
  erb :final
end
