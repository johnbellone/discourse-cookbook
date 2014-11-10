#
# Cookbook Name:: discourse
# Attribute:: chef-vault
# License:: Apache 2.0 (see http://www.apache.org/licenses/LICENSE-2.0)
#
default['chef-vault']['bag_name'] = 'secrets'
default['chef-vault']['admins'] = %w(jbellone)
default['chef-vault']['search'] = '*:*'
