class epics_gateway::params {
  $package_ensure = 'present'
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true
  $console_port   = 4051
  $server_port    = 5064
  $client_port    = 5064
  $gw_params      = ''
  $home_dir       = '/var/run/${NAME}'
  $pv_list        = '/etc/epics/${NAME}/pvlist'
  $access_file    = '/etc/epics/${NAME}/access'
  $command_file   = '/etc/epics/${NAME}/command'
  $archive        = true
  $no_cache       = true
  $caputlog       = false
  $caputlog_host  = 'localhost'
  $caputlog_port  = 7004

  case $::osfamily {
    'Debian': {
      $package_name = [ 'epics-cagateway' ]
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}