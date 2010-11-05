require 'server'

namespace :dj do

  desc "Start DelayedJob worker"
  task :work do
    Delayed::Worker.backend = :data_mapper
    Delayed::Job.auto_migrate!
    Delayed::Worker.new.start
  end

end
