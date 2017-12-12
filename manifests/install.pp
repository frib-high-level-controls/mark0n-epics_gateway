# Install software needed to run one or more cagateways
#
class epics_gateway::install(
  String $package_name   = $epics_gateway::params::package_name,
  String $package_ensure = $epics_gateway::params::package_ensure,
) {
  package { 'procserv':
    ensure => 'latest',
  }

  package { 'EPICS Channel Access Gateway':
    ensure => $package_ensure,
    name   => $package_name,
  }

  # init script uses sed for extracting the PID of the gateway process from its
  # "kill" file
  if !defined(Package['sed']) {
    package { 'sed':
      ensure => installed,
    }
  }

  # init script uses kill command to trigger a reload of the access security
  # files
  if !defined(Package['procps']) {
    package { 'procps':
      ensure => installed,
    }
  }
}
