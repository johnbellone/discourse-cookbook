#
# Cookbook Name:: discourse
# Attribute:: default
# License:: Apache 2.0 (see http://www.apache.org/licenses/LICENSE-2.0)
#
default['discourse']['artifact_location'] = "https://github.com/discourse/discourse/archive/v%{version}.tar.gz"
default['discourse']['artifact_version'] = '1.1.0'

default['discourse']['site_name'] = 'meta.discourse.org'
default['discourse']['site_root'] = "/srv/%{name}"
default['discourse']['site_environment'] = { rails_env: 'production' }

default['discourse']['user'] = 'discourse'
default['discourse']['group'] = 'discourse'
