# Configure all instance-specific things.
#
define epics_gateway::gateway(
  $service_ensure            = $epics_gateway::params::service_ensure,
  $service_enable            = $epics_gateway::params::service_enable,
  $service_manage            = $epics_gateway::params::service_manage,
  $console_port              = $epics_gateway::params::console_port,
  $server_ip                 = undef,
  $client_ip                 = undef,
  $server_port               = $epics_gateway::params::server_port,
  $client_port               = $epics_gateway::params::client_port,
  $ignore_ips                = [],
  $cas_beacon_auto_addr_list = undef,
  $cas_beacon_addr_list      = undef,
  $env_vars                  = {},
  $gw_params                 = $epics_gateway::params::gw_params,
  $home_dir                  = "/var/run/${name}",
  $pv_list                   = "/etc/epics/cagateway/${name}/pvlist",
  $access_file               = "/etc/epics/cagateway/${name}/access",
  $command_file              = "/etc/epics/cagateway/${name}/command",
  $log_file                  = "/var/log/cagateway/${name}.log",
  $archive                   = $epics_gateway::params::archive,
  $no_cache                  = $epics_gateway::params::no_cache,
  $caputlog                  = $epics_gateway::params::caputlog,
  $caputlog_host             = $epics_gateway::params::caputlog_host,
  $caputlog_port             = $epics_gateway::params::caputlog_port,
  $prefix                    = $epics_gateway::params::prefix,
  $debug                     = 0,
) {
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_bool($service_manage)
  validate_string($server_ip)
  validate_string($client_ip)
  validate_array($ignore_ips)
  validate_string($gw_params)
  validate_absolute_path($home_dir)
  validate_string($log_file)
  validate_bool($archive)
  validate_bool($no_cache)
  validate_bool($caputlog)
  validate_string($caputlog_host)
  validate_string($prefix)
  validate_hash($env_vars)

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

  if $cas_beacon_auto_addr_list != undef {
    validate_bool($cas_beacon_auto_addr_list)
    $cas_beacon_auto_list_str = $cas_beacon_auto_addr_list ? {
      true  => 'YES',
      false => 'NO',
    }
    $env_vars2 = merge($env_vars, {'EPICS_CAS_BEACON_AUTO_ADDR_LIST' => $cas_beacon_auto_list_str})
  } else {
    $env_vars2 = $env_vars
  }

  if $cas_beacon_addr_list {
    validate_string($cas_beacon_addr_list)
    $real_env_vars = merge($env_vars2, {'EPICS_CAS_BEACON_ADDR_LIST' => $cas_beacon_addr_list})
  } else {
    $real_env_vars = $env_vars2
  }

  file { "/etc/systemd/system/${name}.service":
    ensure => file,
    content => template("${module_name}/etc/systemd/system/cagateway.service"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['reload systemd configuration'],
  }

  file { "/var/run/${name}":
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
      name       => "${name}",
      require    => File["/var/run/${name}"],
      subscribe  => [
        Exec['reload systemd configuration'],
      ],
    }
  }
}
