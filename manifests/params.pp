class epics_gateway::params {
  $package_ensure = 'present'
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true

  case $::osfamily {
    'Debian': {
      $package_name = 'epics-cagateway'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}