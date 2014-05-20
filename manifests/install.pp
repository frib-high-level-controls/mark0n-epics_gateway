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
    name   => $package_name,
    ensure => $package_ensure,
  }
}
