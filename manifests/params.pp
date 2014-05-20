class epics_gateway::params {
  $package_ensure = 'present'
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true
  $console_port   = 4051
  $gw_params      = ''
  $home_dir       = undef
  $pv_list        = 'GATEWAY.pvlist'
  $access_file    = 'GATEWAY.access'
  $cmd_file       = 'GATEWAY.command'

  case $::osfamily {
    'Debian': {
      $package_name = [ 'epics-cagateway' ]
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}