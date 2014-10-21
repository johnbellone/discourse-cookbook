require 'spec_helper'

describe_recipe 'discourse::default' do
  it { expect(chef_run).to include_recipe('postgresql::client') }
  it { expect(chef_run).to create_group('discourse').with(system: true) }
  it do
    expect(chef_run).to create_user('discourse')
      .with(system: true)
      .with(gid: 'discourse')
  end
  it do
    expect(chef_run).to create_directory('/srv/meta.discourse.org')
      .with(user: 'discourse')
      .with(group: 'discourse')
      .with(recursive: true)
  end
end
