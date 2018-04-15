# setup script here

# These 6 lines are used to run recipes in other cookbooks
include_recipe "ruby-ng::dev" # installs Ruby v2 and above
include_recipe "nodejs" # installs nodejs
include_recipe "nodejs::npm" # install npm
include_recipe "postgres" # installs postgres client libraries
include_recipe "nginx" # installs nginx w/ default settings
include_recipe "unicorn" # installs unicorn

# machine level dependencies needed to be installed to prepare machine for running your app
apt_package 'zlib1g-dev'
apt_package 'libpq-dev'

# init.d is a service that enables easy starting and stopping of a long running application
template "eventlistenr_service" do
    path "/etc/init.d/eventlistenr"
    source "eventlistenr_service.erb"
    owner "root"
    group "root"
    mode "0755"
end

service "eventlistenr" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action [ :enable ]
end

# We are using Nginx as our web server. Nginx reads config files that are "symlinked" from /nginx/sites_available
template "#{node['nginx']['dir']}/sites-available/eventlistenr" do
  source 'eventlistenr_site.erb'
  notifies :reload, 'service[nginx]', :delayed
end

nginx_site 'eventlistenr' do
  action :enable
end

# We are using Unicorn as our production app server. Unicorn starts multiple instances of app, and monitors them for failure. Unicorn talks with Nginx over Unix sockets. We create a directory to store Unix socket.
directory '/tmp/sockets/' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

unicorn_config "/opt/unicorn.rb" do
  listen ({"unix:/tmp/sockets/unicorn.sock": nil})
  working_directory node[:eventlistenr][:path]
  # /config/unicorn.rb
end
