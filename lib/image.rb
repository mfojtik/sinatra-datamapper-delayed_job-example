class Image
  include DataMapper::Resource

  property :id, Serial
  property :pid, String

  property :name, String
  property :description, Text
  property :architecture, String
  property :owner_id, String

  belongs_to :provider

end
