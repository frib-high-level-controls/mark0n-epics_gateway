class epics_gateway::install inherits epics_gateway {
  package { 'procServ':
    ensure => 'latest',
  }

  package { 'EPICS Channel Access Gateway':
    ensure => $package_ensure,
    name   => $package_name,
  }
}
