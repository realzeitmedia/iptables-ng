require File.expand_path('../support/helpers', __FILE__)

describe 'iptables-ng::rule-create-default' do
  include Helpers::TestHelpers

  it 'should set SSH iptables rule' do
    file('/etc/iptables.d/filter/INPUT/ssh.rule_v4').must_include('--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT')
  end

  it 'should set SSH ip6tables rule' do
    file('/etc/iptables.d/filter/INPUT/ssh.rule_v6').must_include('--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT')
  end

  it 'should enable iptables serices' do
    service(node['iptables-ng']['service_ipv4']).must_be_enabled if node['iptables-ng']['service_ipv4']
    service(node['iptables-ng']['service_ipv6']).must_be_enabled if node['iptables-ng']['service_ipv6']
  end

  it 'should apply the specified iptables rules' do
    ipv4 = shell_out('iptables -L -n')
    ipv4.stdout.must_include('tcp dpt:22 state NEW')

    ipv6 = shell_out('ip6tables -L -n')
    ipv6.stdout.must_include('tcp dpt:22 state NEW')
  end
end