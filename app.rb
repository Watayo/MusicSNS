require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

get '/' do
  erb :index
end

get '/signup' do
  erb :sign_up
end

post '/signup' do
  user = User.create(
    User.params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
  )
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/'
end
