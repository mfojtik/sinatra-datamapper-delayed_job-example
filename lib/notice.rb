class Notice
  include DataMapper::Resource

  property :id, Serial
  property :kind, String, :default => 'APPLICATION'
  property :level, String, :default => 'INFO'
  property :entry, Text
  property :created_on, Date
end
