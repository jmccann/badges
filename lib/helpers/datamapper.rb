require 'sinatra'
require 'data_mapper'

configure :production, :test do
  if ENV['DATABASE_DRIVER'] == 'sqlite3'
    DataMapper.setup(:default, "sqlite3://#{ENV['DATABASE_CONFIG']}")
  else
    DataMapper.setup(:default, ENV['DATABASE_CONFIG'])
  end
end

configure :development do
  DataMapper.setup(:default, 'sqlite::memory:')
end

#
# Data structure for a Badge
#
class Badge
  include DataMapper::Resource
  property :name, String, required: true, key: true
  property :owner, String, required: true, key: true
  property :project, String, required: true, key: true
  property :branch, String, required: true, key: true
  property :full_name, String
  property :image, String, required: true, length: 1500
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Badge.auto_upgrade!
