# defaults are declared in this file
default['ruby-ng']['ruby_version'] = "2.4"
default['nodejs']['version'] = "6.10.1"
default['nodejs']['npm']['version'] = "5.2.0"
default['nginx']['default_site_enabled'] = false

default[:eventlistenr][:git_repository] = "https://github.com/gevuong/EventListenr"
default[:eventlistenr][:git_revision] = "master"
default[:eventlistenr][:path] = "/opt/eventlistenr"

default[:eventlistenr][:rails_env] = "production"

default[:eventlistenr][:environment] = {
  "SECRET_KEY_BASE": node[:eventlistenr][:secret_key_base],
  "DATABASE_URL": node[:eventlistenr][:database_url],
  "RAILS_ENV": node[:eventlistenr][:rails_env]
}

# env_str = environment.map {|k,v| "#{k}=#{v}"}.join(' ')

default[:eventlistenr][:start_cmd] = "unicorn -E production -c /opt/unicorn.rb"
