# default parameters for classes epics_gateway and epics_gateway::gateway
#
class epics_gateway::params {
  $package_ensure = 'present'
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true
  $console_port   = 4051
  $server_port    = 5064
  $client_port    = 5064
  $gw_params      = ''
  $archive        = true
  $no_cache       = true
  $caputlog       = false
  $caputlog_host  = 'localhost'
  $caputlog_port  = 7004
  $tmp            = "\${NAME}"
  $prefix         = "${::hostname}-${tmp}"
  $user           = 'cagateway'
  $debug          = 0

  case $::osfamily {
    'Debian': {
      $package_name = 'epics-cagateway'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
