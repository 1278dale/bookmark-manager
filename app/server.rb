require 'data_mapper'
require 'sinatra'
require './lib/link'
require './lib/tag'
require './lib/user'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'
require 'rack-flash'

enable :sessions
set :session_secret, 'super secret'

set :views, Proc.new{File.join(root, 'views')}

use Rack::Flash

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


post '/users' do
  @user = User.create(:email => params[:email], 
                      :password => params[:password],
                      :password_confirmation => params[:password_confirmation])
  if @user.save
  session[:user_id] = @user.id
  redirect to('/')
else
  flash.now[:errors] = @user.errors.full_messages
  # Note that we're switching to using flash[:errors] instead of flash[:notice]. Given that these errors prevent us from proceeding further, it's more appropriate to call them errors.
  erb :"users/new"
  end
end

# We're also using flash.now instead of just flash. By default, a flash message is available for both the current request and the next request. This is very convenient if we're doing a redirect. However, since we are just re-rendering the page, we just want to show the flash for the current request, not for the next one. If we use flash[:errors], then after the user fixes the mistakes, we'll be redirected to the homepage where we'll see our message again.



