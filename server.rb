require 'rubygems'
require 'sinatra'
require 'deltacloud'
require 'database_initializer'
require 'delayed_job'
require 'haml'

# Sinatra settings
enable :inline_templates

# Delayed job settings

get '/' do
  haml :index
end

post '/jobs' do
  Delayed::Worker.backend = :data_mapper
  inst_job = InstanceJob.create(:command => params[:cmd])
  job = Delayed::Job.enqueue(inst_job)
  puts "************************"
  puts "************************"
  job.invoke_job
  redirect '/'
end

get '/jobs' do
  @inst_jobs = InstanceJob.all
  @dj_jobs = Delayed::Job.all
  haml :jobs
end

__END__

@@ index
%h2 Enter command
%form{:action => "/jobs", :method => "POST"}
  %input{ :name => "cmd", :type => :text, :value => ''}
  %input{ :type => :submit }

@@ jobs
%h2 InstanceJobs

%table
  - @inst_jobs.each do |j|
    %tr
      %td #{j.id}
      %td #{j.state}
      %td #{j.command}

%h2 DelayedJobs

%table
  - @dj_jobs.each do |j|
    %tr
      %td #{j.inspect}
