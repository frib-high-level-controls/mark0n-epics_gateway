# Install software needed to run one or more cagateways
#
class epics_gateway::install(
  $package_name   = $epics_gateway::params::package_name,
  $package_ensure = $epics_gateway::params::package_ensure,
) {
  validate_array($package_name)
  validate_string($package_ensure)

  package { 'procserv':
    ensure => 'latest',
  }

  package { 'EPICS Channel Access Gateway':
    ensure => $package_ensure,
    name   => $package_name,
  }

  if !defined(Package['sed']) {
    package { 'sed':
      ensure => installed,
    }
  }

  if !defined(Package['procps']) {
    package { 'procps':
      ensure => installed,
    }
  }
}
