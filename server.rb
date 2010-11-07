require 'rubygems'
require 'initializer'
require 'sinatra'
require 'sass'
require 'deltacloud'
require 'sinatra/respond_to'
require "sinatra/reloader" if development?

# Sinatra settings
enable :inline_templates
Sinatra::Application.register Sinatra::RespondTo
DataMapper::Logger.new($stdout, :debug)

# Delayed job settings

get '/' do
  redirect '/instances'
end

get '/style.css' do
  scss :style
end

get '/instances' do
  @instances = Instance.all
  respond_to do |wants|
    wants.html { haml :instances_index }
  end
end

get '/instances/:id' do
  @instance = Instance.get(params[:id])
  respond_to do |wants|
    wants.html { haml :instance }
  end
end

post '/instances' do
  instance = Instance.create(params[:instance])
  redirect '/instances'
end

__END__

@@ layout.html

%html
  %head
    %title Testing delayed_job
    %link{"rel" => "stylesheet", "href" => "/fluid_grid.css", "type" => "text/css"}
    %link{"rel" => "stylesheet", "href" => "/style.css", "type" => "text/css"}
    %script{:type => "text/javascript", :src => "/jquery-1.4.3.min,js"}
  %body
    %div.container_12
      %div.grid_2.menu
        =haml(:menu, :layout => false)
      %div.grid_10
        =yield

@@ menu.html
%ul
  %li
    %a{:href => "/providers"} Providers
  %li
    %a{:href => "/instances"} Instances
  %li
    %a{:href => "/scripts"} Scripts
  %li
    %a{:href => "/jobs"} Jobs

@@ providers_index.html


@@ style

$font: 'Helvetica Neue', 'Liberation Sans', Arial, sans-serif;

body {
  font-family : $font;
  font-size : 12px;
}

table, table td {
  border : 1px solid #ccc;
}

table td.pre {
  font : monospace;
  white-space : pre;
}

.menu li {
  list-style : none;
}
