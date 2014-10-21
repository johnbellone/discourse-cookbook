#
# Cookbook Name:: discourse
# Recipe:: default
#
# Copyright (C) 2014 John Bellone (<jbellone@bloomberg.net>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'postgresql::client'

root_path = node['discourse']['root_path'] % { name: node['discourse']['site_name'] }

group node['discourse']['group'] do
  system true
end

user node['discourse']['user'] do
  gid node['discourse']['group']
  system true
end

ruby_install_ruby '2.0.0' do
  user node['discourse']['user']
  group node['discourse']['group']
  gems %w(bundler puma nokogiri redis)
end

directory root_path do
  user node['discourse']['user']
  group node['discourse']['group']
  recursive true
  not_if { ::Dir.exist? root_path }
end

artifact_deploy node['discourse']['site_name'] do
  version node['discourse']['artifact_version']
  artifact_location node['discourse']['artifact_location'] % { version: node['discourse']['artifact_version'] }
  deploy_to root_path
  owner node['discourse']['user']
  group node['discourse']['group']
  environment node['discourse']['site_environment']
  shared_directories %w(data log pids system assets)
end
