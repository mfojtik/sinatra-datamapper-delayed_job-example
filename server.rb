require 'rubygems'
require 'initializer'
require 'sinatra'

# Sinatra settings
enable :inline_templates

DataMapper::Logger.new($stdout, :debug)

# Delayed job settings

get '/' do
  haml :index
end

post '/jobs' do
  inst_job = InstanceJob.create(:command => params[:cmd])
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
