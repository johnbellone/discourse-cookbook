require 'chefspec'
require 'chefspec/berkshelf'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |config|
  config.color = true
  config.alias_example_group_to :describe_recipe, type: :recipe

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  Kernel.srand config.seed
  config.order = :random

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end

at_exit { ChefSpec::Coverage.report! }

RSpec.shared_context 'recipe tests', type: :recipe do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.default['dev_mode'] = true
    end.converge(described_recipe)
  end
end
