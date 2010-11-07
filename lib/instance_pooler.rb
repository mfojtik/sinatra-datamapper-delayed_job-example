class InstancePooler
  include DataMapper::Resource

  property :id, Serial
  property :pool_count, Integer, :default => 0
  belongs_to :instance

  after :create do
    Delayed::Job.enqueue(self)
  end

  after :update do
    Delayed::Job.enqueue(self)
  end

  def perform
    unless self.instance.provider.is_active
      Notice.create(:kind => "POOLER", :message => "Disabled pooling for Instance#{self.instance.id}. Provider down.", :level => "INFO")
      return
    end
    client = DeltaCloud::new(self.provider.username, self.provider.password, self.provider.url)
    provider_instance = client.instance(self.instance.provider_id)
    self.instance.update(:status => provider_instance.state)
    # Continuing with pooling
    self.update(:pool_count => self.pool_count+1)
  end


end
