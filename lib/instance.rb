class Instance
  include DataMapper::Resource

  property :id, Serial
  property :pid, String

  belongs_to :provider
  belongs_to :image
  belongs_to :realm
  belongs_to :hardware_profile
  belongs_to :authentication_key

  has 1, :instance_pooler, :required => false

  property :name, String
  property :state, String, :required => true, :default => "NEW"
  property :runtime, Integer, :default => 0
  property :created_on, Date
  property :updated_at, DateTime
  property :updated_on, Date
  property :destroyed_at, Date

  after :create do
    Delayed::Job.enqueue(self)
  end

  def perform
    self.update(:state => "PROVIDER_CONNECTING")
    client = DeltaCloud::new(self.provider.username, self.provider.password, self.provider.url)
    self.update(:state => "PROVIDER_DEPLOYING")
    begin
      instance = client.create_instance(self.image.pid, {
        :realm_id => self.realm.pid,
        :key_name => self.authentication_key.pid,
        :hardware_profile => self.hardware_profile.pid
      })
      if instance and instance.id
        self.update(
          :state => instance.state,
          :pid => instance.id,
          :instance_pooler => InstancePooler.create(:instance => self)
        )
      else
        Notice.create(:kind => "PROVIDER", :entry => "Instance could not be started. Reason unknown", :level => "FAILURE")
      end
    rescue Exception => e
      Notice.create(:kind => "PROVIDER", :entry => e.message, :level => "FAILURE")
      return
    end
  end

end
