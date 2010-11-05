class InstanceJob
  include DataMapper::Resource
  yaml_as "tag:ruby.yaml.org,2002:InstanceJob"

  property :id, Serial
  property :command, Text
  property :state, String, :default => "NEW"
  
  def perform
    $stdout.puts "********* Started perfoming a job *******"
    self.update(:state => "RUNNING")
    sleep(2)
    self.update(:state => "COMPLETE")
    $stdout.puts "********* Completed perfoming a job *******"
  end

  def self.yaml_new(klass, tag, val)
    klass.get(val['id'])
  end

  def to_yaml_properties
    [ '@id', '@command', '@state' ]
  end


end
