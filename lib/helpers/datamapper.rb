require 'sinatra'
require 'data_mapper'

# need install dm-sqlite-adapter
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/badges.db")

#
# Data structure for a Badge
#
class Badge
  include DataMapper::Resource
  property :id, Serial
  property :name, String, required: true, key: true
  property :owner, String, required: true, key: true
  property :project, String, required: true, key: true
  property :full_name, String
  property :image, String, required: true, length: 1500
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Badge.auto_upgrade!
