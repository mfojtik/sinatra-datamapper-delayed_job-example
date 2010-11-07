class HardwareProfile
  include DataMapper::Resource

  property :id, Serial
  property :pid, String

  property :cpus, String
  property :memory, String
  property :storage, String
  property :architecture, String

  belongs_to :provider
end
