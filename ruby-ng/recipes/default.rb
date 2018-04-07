include_recipe 'apt'

name = "ruby-ng#{'-experimental' if node['ruby-ng']['experimental']}"

apt_repository "brightbox-#{name}" do
  uri "http://ppa.launchpad.net/brightbox/#{name}/ubuntu"
  distribution node['lsb']['codename']
  components [ 'main' ]
  keyserver 'keyserver.ubuntu.com'
  key 'C3173AA6'
end

apt_preference 'ruby-ng-01-disable_by_default' do
  glob '*'
  pin "release o=LP-PPA-brightbox-#{name}"
  pin_priority '-1'
end

apt_preference 'ruby-ng-02-enable_for_ruby' do
  glob 'ruby* libruby*'
  pin "release o=LP-PPA-brightbox-#{name}"
  pin_priority '666'
end

package "ruby#{node['ruby-ng']['ruby_version']}"

gem_package 'bundler' do
  gem_binary '/usr/bin/gem'
  options '-n /usr/bin'
end
