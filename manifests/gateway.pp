# Configure all instance-specific things.
#
define epics_gateway::gateway(
  $service_ensure = $epics_gateway::params::service_ensure,
  $service_enable = $epics_gateway::params::service_enable,
  $service_manage = $epics_gateway::params::service_manage,
  $console_port   = $epics_gateway::params::console_port,
  $server_ip      = undef,
  $client_ip      = undef,
  $server_port    = $epics_gateway::params::server_port,
  $client_port    = $epics_gateway::params::client_port,
  $ignore_ips     = [$server_ip],
  $gw_params      = $epics_gateway::params::gw_params,
  $home_dir       = $epics_gateway::params::home_dir,
  $pv_list        = $epics_gateway::params::pv_list,
  $access_file    = $epics_gateway::params::access_file,
  $command_file   = $epics_gateway::params::command_file,
  $log_file       = $epics_gateway::params::log_file,
  $archive        = $epics_gateway::params::archive,
  $no_cache       = $epics_gateway::params::no_cache,
  $caputlog       = $epics_gateway::params::caputlog,
  $caputlog_host  = $epics_gateway::params::caputlog_host,
  $caputlog_port  = $epics_gateway::params::caputlog_port,
  $prefix         = $epics_gateway::params::prefix,
) {
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_bool($service_manage)
  validate_string($server_ip)
  validate_string($client_ip)
  validate_array($ignore_ips)
  validate_string($gw_params)
  validate_string($log_file)
  validate_bool($archive)
  validate_bool($no_cache)
  validate_bool($caputlog)
  validate_string($caputlog_host)
  validate_string($prefix)

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

  if !is_integer($server_port) or $server_port < 0 or $server_port > 65535 {
    fail('server_port is not a valid port number')
  }

  if !is_integer($client_port) or $client_port < 0 or $client_port > 65535 {
    fail('client_port is not a valid port number')
  }

  if !is_integer($caputlog_port) or $caputlog_port < 0 or $caputlog_port > 65535 {
    fail('caputlog_port is not a valid port number')
  }

  file { "/etc/default/cagateway-${name}":
    ensure  => file,
    content => template("${module_name}/etc/default/cagateway"),
    owner   => 'root',
    mode    => '0644',
  }

  file { "/etc/init.d/cagateway-${name}":
    ensure => link,
    target => '/etc/init.d/cagateway',
  }

  file { "/var/run/cagateway-${name}":
    ensure => directory,
    owner  => 'cagateway',
    mode   => '0755',
  }

  if $service_manage == true {
    service { "EPICS Channel Access Gateway ${name}":
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasrestart => true,
      hasstatus  => true,
      name       => "cagateway-${name}",
      require    => File["/var/run/cagateway-${name}"],
      subscribe  => [
        File["/etc/init.d/cagateway-${name}"],
        File["/etc/default/cagateway-${name}"],
      ],
    }
  }

  file { "/usr/local/bin/cagateway-${name}-report.sh":
    ensure  => file,
    content => template("${module_name}/usr/local/bin/cagateway-report.sh"),
    owner   => 'root',
    mode    => '0755',
  }
}