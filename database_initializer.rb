require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'active_support'
require 'instance_job'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.sqlite")
DataMapper.auto_migrate!

