define epics_gateway::gateway(
  $service_ensure = $epics_gateway::params::service_ensure,
  $service_enable = $epics_gateway::params::service_enable,
  $service_manage = $epics_gateway::params::service_manage,
  $console_port   = $epics_gateway::params::console_port,
  $server_ip      = undef,
  $client_ip      = undef,
  $ignore_ips     = [$server_ip],
  $gw_params      = $epics_gateway::params::gw_params,
  $home_dir       = $epics_gateway::params::home_dir,
  $pv_list        = $epics_gateway::params::pv_list,
  $access_file    = $epics_gateway::params::access_file,
  $cmd_file       = $epics_gateway::params::cmd_file,
) {
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_bool($service_manage)
  validate_string($server_ip)
  validate_string($client_ip)
  validate_array($ignore_ips)
  validate_string($gw_params)

  if !($service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if !is_integer($console_port) or $console_port < 0 or $console_port > 65535 {
    fail('console_port is not a valid port number')
  }

  if !is_ip_address($server_ip) {
    fail('server_ip is not a valid ip address')
  }

  if !is_ip_address($client_ip) {
    fail('client_ip is not a valid ip address')
  }

  file { "/etc/default/cagateway-${name}":
    ensure  => file,
    content => template("${module_name}/etc/default/cagateway"),
    owner   => 'root',
    mode    => '0644',
  }

  file { "/etc/init.d/cagateway-${name}":
    ensure  => file,
    content => template("${module_name}/etc/init.d/cagateway"),
    owner   => 'root',
    mode    => '0755',
  }

  if $service_manage == true {
    service { "EPICS Channel Access Gateway ${name}":
      name       => "cagateway-${name}",
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasrestart => true,
      hasstatus  => true,
      subscribe  => [
        File["/etc/init.d/cagateway-${name}"],
        File["/etc/default/cagateway-${name}"],
      ],
    }
  }
}