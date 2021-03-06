require 'bcrypt'
require 'data_mapper'

class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String, :unique => true, :message => "This email has already been taken"

  
  # this will store both the password and the salt
  # It's Text and not String because String holds
  # 50 characters by default
  # and it's not enough for the hash and salt
  property :password_digest, Text

  attr_reader :password
  attr_accessor :password_confirmation
# this is datamapper's method of validating the model.
# The model will not be saved unless both password
# and password_confirmation are the same
# read more about it in the documentation
# http://datamapper.org/docs/validations.html
  validates_confirmation_of :password, :message => "Sorry, your passwords don't match"

# ((((The reason we need the reader for :password and :password_confirmation is that datamapper should have access to both values to make sure they are the same.

# The reason we need the writer for :password_confirmation is that we're now passing the password confirmation to the model in the controller.))))

  # when assigned the password, we don't store it directly
  # instead, we generate a password digest, that looks like this:
  # "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. This digest, provided by bcrypt,
  # has both the password hash and the salt. We save it to the
  # database instead of the plain password for security reasons.

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  

 end 

end