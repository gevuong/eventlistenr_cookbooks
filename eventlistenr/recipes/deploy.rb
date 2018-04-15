# deploy script here

=begin
For each deploy, we will:
1. Stop existing service
2. Create a directory
3. Git checkout latest version of master branch
4. Install all dependencies
5. Restart service
=end
service "eventlistenr" do
  action [:stop]
end

directory "#{node[:eventlistenr][:path]}" do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  recursive true
  action :create
end

# deploy script here

# Git chef resource allows you to checkout a git repo by passing branches/commit hash in as attributes/custom JSON.
git "#{node[:eventlistenr][:path]}" do
  repository node[:eventlistenr][:git_repository]
  revision node[:eventlistenr][:git_revision]
  environment ({"HOME"=>"/home/ubuntu"})
  action :sync
  user "ubuntu"
end

# bundle install, npm install, compile static webpack and rails assets. If CDN is used, you can avoid these steps. 
execute "Install Gems" do
  cwd node[:eventlistenr][:path]
  command "bundle install"
  user "ubuntu"
  # group new_resource.group
  environment ({"HOME"=>"/home/ubuntu"})
  # not_if { package_installed? }
end

execute "Install NPM packages" do
  cwd node[:eventlistenr][:path]
  command "npm install"
  user "ubuntu"
  # group new_resource.group
  environment ({"HOME"=>"/home/ubuntu"})
  # not_if { package_installed? }
end

execute "Compile Webpack Assets" do
  cwd node[:eventlistenr][:path]
  command "./node_modules/.bin/webpack"
  environment ({"NODE_ENV": "production", "HOME": "/home/ubuntu"})
  user "ubuntu"
end

execute "Clobber Rails Assets" do
  cwd node[:eventlistenr][:path]
  command "bundle exec rake assets:clobber"
  environment ({"RAILS_ENV": "production", "HOME": "/home/ubuntu"})
  user "ubuntu"
end

execute "Compile Rails Assets" do
  cwd node[:eventlistenr][:path]
  command "bundle exec rake assets:precompile"
  environment ({"RAILS_ENV": "production", "HOME": "/home/ubuntu"})
  user "ubuntu"
end

service "eventlistenr" do
  action [ :enable, :start ]
end
