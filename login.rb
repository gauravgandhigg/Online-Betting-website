require 'dm-core'
require 'dm-migrations'

DataMapper::Logger.new($stdout,:debug)
DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/login_info.db")
class Login_info
    include DataMapper::Resource
    property :id, Serial
    property :username, Text
    property :password, Text
    property :total, Integer
    property :won, Integer
end
DataMapper.finalize