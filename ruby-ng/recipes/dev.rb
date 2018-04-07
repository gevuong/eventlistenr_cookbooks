include_recipe 'build-essential'
include_recipe 'ruby-ng::default'

package "ruby#{node['ruby-ng']['ruby_version']}-dev"
