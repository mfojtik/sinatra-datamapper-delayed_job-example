class AuthenticationKey
  include DataMapper::Resource

  property :id, Serial
  property :pid, String

  belongs_to :provider
  property :data, Text

end
