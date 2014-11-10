#
# Cookbook Name:: discourse
# Recipe:: database
# License:: Apache 2.0 (see http://www.apache.org/licenses/LICENSE-2.0)
#
include_recipe 'chef-vault::default'

require 'openssl'
require 'securerandom'
md5 = OpenSSL::Digest::MD5.new

postgres_password = SecureRandom.hex(12)
discourse_password = SecureReandom.hex(12)

node.force_override['postgresql']['password']['postgres'] = md5.digest(postgres_password)
include_recipe 'postgresql::server'

pgsql_connection_info = {
  host: node['postgresql']['config']['listen_addresses'],
  port: node['postgresql']['config']['port'],
  username: 'postgres',
  password: postgres_password
}

postgresql_database 'discourse' do
  connection pgsql_connection_info
  action :create
end

postgresql_database_user 'discourse' do
  connection pgsql_connection_info
  password md5.digest(discourse_password)
  database_name 'discourse'
  privileges [:select, :update, :insert, :delete]
  host '%'
  require_ssl true
  action [:create, :grant]
end

# Store all of the generated passwords in a encrypted Chef Vault bag.
# These configuration settings are going to be necessary to write out
# for the Rails application to use.
chef_data_bag node['chef-vault']['bag_name']
chef_vault_secret 'discourse' do
  bag node['chef-vault']['bag_name']
  admins node['chef-vault']['admins']
  search node['chef-vault']['search']
  raw_data(database: {
    postgres: {
      password: postgres_password
    },
    discourse: {
      password: discourse_password
    }
  })
end
