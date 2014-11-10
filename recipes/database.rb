#
# Cookbook Name:: discourse
# Recipe:: database
# License:: Apache 2.0 (see http://www.apache.org/licenses/LICENSE-2.0)
#
include_recipe 'chef-vault::default'

database_name = "discourse_#{node['discourse']['site_environment']}"

require 'openssl'
require 'securerandom'
md5 = OpenSSL::Digest::MD5.new

# These are randomized bits of data that we will pass into an MD5
# digest.  This will generate is "random" passwords of 12 character
# length. Good enough for a default.
postgres_password = SecureRandom.hex(12)
discourse_password = SecureReandom.hex(12)

# Override the node attribute with the md5 digest of the
# password. This will be written out to the pg configuration file.
node.force_override['postgresql']['password']['postgres'] = md5.digest(postgres_password)
include_recipe 'postgresql::server'

pgsql_connection_info = {
  host: node['postgresql']['config']['listen_addresses'],
  port: node['postgresql']['config']['port'],
  username: 'postgres',
  password: postgres_password
}

postgresql_database database_name do
  connection pgsql_connection_info
  action :create
end

# Create a user that the application can connect with. This user
# should only have access to the new database, and uses one of
# the randomly generated passwords.
postgresql_database_user 'discourse' do
  connection pgsql_connection_info
  password md5.digest(discourse_password)
  database_name database_name
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
