require 'data_mapper'
require 'sinatra'
require './lib/link'
require './lib/tag'
require './lib/user'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'

enable :sessions
set :session_secret, 'super secret'

set :views, Proc.new{File.join(root, 'views')}

# env = ENV["RACK_ENV"] || "development"
# # we're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the environment
# DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

# require './lib/link' # this needs to be done after datamapper is initialised

# # After declaring your models, you should finalise them
# DataMapper.finalize
  
# # However, the database tables don't exist yet. Let's tell datamapper to create them
# DataMapper.auto_upgrade!

get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map do |tag|
    Tag.first_or_create(:text => tag)
  end
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  #note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the 
  # variable new (which makes no sense)
  @user = User.new
  erb :"users/new"
end

post '/users/new' do
  @user = User.create(:email => params[:email],
              :password => params[:password])
  session[:user_id] = @user.id
  redirect to('/')
end

post '/users' do
  user = User.create(:email => params[:email], :password => params[:password],
                     :password_confirmation => params[:password_confirmation])
  session[:user_id] = @user.id
  redirect to('/')
  end

