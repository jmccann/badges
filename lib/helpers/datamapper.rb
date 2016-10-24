require 'sinatra'
require 'data_mapper'

# need install dm-postgres-adapter
def postgres_connection # rubocop:disable AbcSize
  raise "Please provide \"ENV['DATABASE_USER']\"" if ENV['DATABASE_USER'].nil?
  if ENV['DATABASE_PASSWORD'].nil?
    raise "Please provide \"ENV['DATABASE_PASSWORD']\""
  end
  raise "Please provide \"ENV['DATABASE_HOST']\"" if ENV['DATABASE_HOST'].nil?
  raise "Please provide \"ENV['DATABASE_NAME']\"" if ENV['DATABASE_NAME'].nil?

  "postgres://#{ENV['DATABASE_USER']}:#{ENV['DATABASE_PASSWORD']}" \
  "@#{ENV['DATABASE_HOST']}/#{ENV['DATABASE_NAME']}"
end

DataMapper.setup(:default, postgres_connection)

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
