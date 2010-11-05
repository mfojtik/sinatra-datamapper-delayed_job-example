require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'delayed_job'
require 'haml'

# DataMapper objects
require 'instance_job'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.sqlite")
DataMapper.auto_migrate!
Delayed::Worker.backend = :data_mapper

module DataMapper
  module Resource
    yaml_as "tag:ruby.yaml.org,2002:#{self.class}"

    def self.yaml_new(klass, tag, val)
      klass.get(val['id'])
    end

    def to_yaml_properties
      [ '@id' ] 
    end
  end
end
