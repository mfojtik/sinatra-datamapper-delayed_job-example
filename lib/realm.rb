class Realm
  include DataMapper::Resource

  property :id, Serial
  property :pid, String
  belongs_to :provider

  property :state, String

end
