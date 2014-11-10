require 'spec_helper'

describe_recipe 'discourse::database' do
  it { expect(chef_run).to include_recipe('chef-vault::default') }
  it { expect(chef_run).to include_recipe('postgresql::server') }
  it { expect(chef_run).to create_postgresql_database('discourse') }
  it { expect(chef_run).to create_postgresql_database_user('discourse') }
end
