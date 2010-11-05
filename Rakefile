require 'initializer'

namespace :dj do

  desc "Start DelayedJob worker"
  task :work do
    DataMapper::Logger.new($stdout, :info)
    Delayed::Worker.backend = :data_mapper
    Delayed::Job.auto_migrate!
    Delayed::Worker.new.start
  end

end
