class Provider
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :url, String, :required => true
  property :username, String
  property :password, String
  property :status, String, :default => "NEW"
  property :is_active, Boolean, :default => false

  has n, :instances
  has n, :hardware_profiles
  has n, :images
  has n, :realms

  after :create do
    Delayed::Job.enqueue(self)
  end

  def perform
    self.update(:status => "IMPORT_HARDWARE_PROFILES")
    DeltaCloud::new(self.username, self.password, self.url) do |client|
      client.hardware_profiles.each do |hp|
        self.hardware_profiles << HardwareProfile.create(
          :pid => hp.id,
          :cpus => hp.cpu ? hp.cpu.value.to_s : 'N/A',
          :memory => hp.memory ? hp.memory.value.to_s : 'N/A',
          :storage => hp.storage ? hp.storage.value.to_s : 'N/A',
          :architecture => hp.architecture ? hp.architecture.value.to_s : 'N/A'
        )
      end

      self.update(:status => "IMPORT_REALMS")
      client.realms.each do |r|
        self.realms << Realm.create(
          :pid => r.id,
          :state => r.state
        )
      end

      self.update(:status => "IMPORT_IMAGES")
      client.images.each do |img|
        self.images << Image.create(
          :pid => img.id,
          :name => img.name,
          :owner_id => img.owner_id,
          :description => img.description,
          :architecture => img.architecture
        )
      end
      self.update(:status => "READY")
    end
  end

end
