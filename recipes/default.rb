#
# Cookbook Name:: discourse
# Recipe:: default
# License:: Apache 2.0 (see http://www.apache.org/licenses/LICENSE-2.0)
#
include_recipe 'postgresql::client'
include_recipe 'ruby-install::default'

root_path = node['discourse']['site_root'] % { name: node['discourse']['site_name'] }

group node['discourse']['group'] do
  system true
end

user node['discourse']['user'] do
  gid node['discourse']['group']
  system true
end

ruby_install_ruby 'ruby 2.1' do
  gems [{ name: 'bundler' }, { name: 'puma' }, { name: 'redis' }, { name: 'pg' }]
end

directory root_path do
  user node['discourse']['user']
  group node['discourse']['group']
  recursive true
  not_if { ::Dir.exist?(root_path) }
end

# GitHub provides an endpoint which runs `git archive` and delivers it.
# We can use this in combination with a release tag to deploy an artifact.
artifact_deploy node['discourse']['site_name'] do
  version node['discourse']['artifact_version']
  artifact_location node['discourse']['artifact_location'] % { version: node['discourse']['artifact_version'] }
  deploy_to root_path
  owner node['discourse']['user']
  group node['discourse']['group']
  environment Hash.new(rails_env: node['discourse']['site_environment'])
  shared_directories %w(data log pids system assets)

  before_migrate Proc.new {
    template "#{shared_path}/database.yml" do
      source 'database.yml.erb'
      owner node['discourse']['user']
      group node['discourse']['group']
      mode '0640'
      variables(environment: environment, options: database_options)
    end
  }

  migrate Proc.new {
    execute %Q(bundle exec rake db:migrate) do
      cwd release_path
      environment environment
      user node['discourse']['user']
      group node['discourse']['group']
    end
  }

  before_deploy Proc.new {
    service 'discourse' do
      action :stop
    end
  }

  configure Proc.new {
    template "#{root_path}/current/.env" do
      source 'env.sh.erb'
      owner node['discourse']['user']
      group node['discourse']['group']
      mode '0640'
      variables(environment: node['discourse']['site_environment'])
    end

    puma_config 'discourse' do
      directory root_path
      logrotate true
      environment node['discourse']['site_environment']
      workers node['cpu']['total']
    end
  }

  restart Proc.new {
    service 'discourse' do
      action :restart
    end
  }
end
