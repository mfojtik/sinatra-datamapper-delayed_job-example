class InstanceJob
  include DataMapper::Resource

  property :id, Serial
  property :command, Text
  property :output, Text
  property :state, String, :default => "NEW"

  after :create do
    Delayed::Job.enqueue(self)
  end
  
  def perform
    $stdout.puts "********* Started perfoming a job *******"
    self.update(:state => "RUNNING")
    self.update(:output => `#{self.command}`)
    self.update(:state => "COMPLETE")
    $stdout.puts "********* Completed perfoming a job *******"
  end

end
