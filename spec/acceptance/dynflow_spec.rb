require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy', unless: ENV['BEAKER_HYPERVISOR'] == 'docker'  do
  before(:context) { purge_installed_packages }

  include_examples 'the example', 'dynflow.pp'

  it_behaves_like 'the default foreman proxy application'

  if os[:family] =~ /redhat|fedora/
    describe service('smart_proxy_dynflow_core') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(8008) do
      it { is_expected.to be_listening }
    end
  else
    describe service('smart_proxy_dynflow_core') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end

    describe port(8008) do
      it { is_expected.not_to be_listening }
    end
  end
end
