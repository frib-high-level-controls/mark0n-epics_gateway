# == Class: epics_gateway
#
# Installs and configures the EPICS Channel Access Gateway. This class manages
# the non-instance specific part which is only needed once whereas
# epics_gateway::gateway should be run for each gateway instance running on the
# managed machine. Examples that might require multiple gateway instances on
# a single machine include
#
# a) A gateway machine providing access to an accelerator network as well as to
#    an experimental network from the office network.
# b) A gateway machine that provides access back and forth between an
#    accelerator network and an experimental network (thus acting as a forward
#    and reverse gateway).
#
# === Examples
# Make PVs from 192.168.1.xxx and 192.168.2.xxx available on 192.168.3.xxx:
#
# class { 'epics_gateway':
#   require => Apt::Source['controls_repo'],
# }
#
# vcsrepo { '/etc/epics/cagateway-192.168.1.xxx':
#   ...
# }
#
# vcsrepo { '/etc/epics/cagateway-192.168.2.xxx':
#   ...
# }
#
# epics_gateway::gateway { '192.168.1.xxx':
#   server_ip => '192.168.3.1',
#   client_ip => '192.168.1.255',
#   require   => Package['ioclogserver'],
#   subscribe => [
#     Vcsrepo['/etc/epics/cagateway-192.168.1.xxx'],
#   ],
# }
#
# epics_gateway::gateway { '192.168.2.xxx':
#   server_ip => '192.168.3.1',
#   client_ip => '192.168.2.255',
#   require   => Package['ioclogserver'],
#   subscribe => [
#     Vcsrepo['/etc/epics/cagateway-192.168.2.xxx'],
#   ],
# }
#
# === Authors
#
# Martin Konrad <konrad@frib.msu.edu>
#
# === Copyright
#
# Copyright 2014 Facility for Rare Isotope Beams (FRIB),
# Michigan State University, East-Lansing, MI, USA
#
class epics_gateway(
  String $package_name    = $epics_gateway::params::package_name,
  String $package_ensure  = $epics_gateway::params::package_ensure,
  Boolean $service_enable = $epics_gateway::params::service_enable,
  String $service_ensure  = $epics_gateway::params::service_ensure,
  String $service_name    = $epics_gateway::params::service_name,
  String $user            = $epics_gateway::params::user,
) inherits epics_gateway::params {
  class { '::epics_gateway::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
  }

  exec { 'reload systemd configuration':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'epics_gateway::begin': } ->
  Class['::epics_gateway::install'] ->
  class { '::epics_gateway::config': } ->
  anchor { 'epics_gateway::end': }
}
