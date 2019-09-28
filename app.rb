require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'net/http'
require 'json'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'dotenv'
require 'cloudinary'
require 'pry'
require './models'

enable :sessions

before do
  Dotenv.load
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key    = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
  end
end

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end


get '/' do
  erb :index
end

get '/signup' do
  erb :sign_up
end

post '/signup' do

  img_url = ''
  if params[:file]
    img = params[:file]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
    #文字列が打ち込まれてる
  end

  user = User.create(
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation],
    #画像を貼ってる
    img: img_url
  )
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/search'
end

get '/search' do
  @musics = []
  #binding.pry
  erb :search
end

post '/search' do
  keyword = params[:keyword]
  uri = URI("https://itunes.apple.com/search")
  uri.query = URI.encode_www_form({ term: keyword, country: "JP", media: "music", limit: 10 })
  res = Net::HTTP.get_response(uri)
  returned_json = JSON.parse(res.body)
  @musics = returned_json["results"]
  #@musics.present?
  #binding.pry
  erb :search
end

get '/signin' do
  erb :sign_in
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/search'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
  #sessionのuserをnilにしてリダイレクト
end

get '/home' do
  erb :home
end