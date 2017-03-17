require 'spec_helper'

# Test groups
describe group('postgres') do
  it { should exist }
end

describe group('bamboo') do
  it { should exist }
end

# Test users
describe user('bamboo') do
  it { should exist }
  it { should belong_to_group 'bamboo' }
  it { should have_login_shell '/bin/bash' }
end

describe user('postgres') do
  it { should exist }
  it { should belong_to_group 'postgres' }
end

describe 'am i running' do
  describe command('curl -L localhost:8085') do
    its(:stdout) { should contain('Welcome to Atlassian Bamboo continuous integration server') }
  end
end
