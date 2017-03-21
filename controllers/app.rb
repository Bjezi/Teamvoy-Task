require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'aescrypt'
require 'URLcrypt'
require_relative '../models/message'
require_relative 'delete_messages'


set :views, Proc.new { File.join(root, "../views") }

before do
 @messages = Message.all
end

get '/' do
  erb :index
end

get '/new' do
  erb :new_message
end

post '/new' do
  if (params[:body] == '' || params[:password] == '')
    erb :new_message
  else
    @message = Message.create(body: AESCrypt.encrypt(params[:body], params[:password]), 
                              password: params[:password],
                              delete_way: params[:delete_way])
    redirect '/'
  end
end

post '/message/:id' do
  @message = Message.find(URLcrypt.decode(params[:id]).to_i)

  if @message.password == params[:confirm_password]
    DeleteMessages.new(URLcrypt.decode(params[:id]).to_i).check_delete_way
    @body = AESCrypt.decrypt(@message.body, params[:confirm_password])
    erb :show
  else
    erb :confirm_pass
  end

end

get '/message/:id' do
    if Message.find_by_id(URLcrypt.decode(params[:id]).to_s) == nil
    redirect '/'
  else
    @message = Message.find(URLcrypt.decode(params[:id]).to_s)
    erb :confirm_pass
  end
end
