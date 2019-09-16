# Configure all instance-specific things.
#
define epics_gateway::gateway(
  String $server_ip,
  String $service_ensure                       = $epics_gateway::params::service_ensure,
  Boolean $service_enable                      = $epics_gateway::params::service_enable,
  Boolean $service_manage                      = $epics_gateway::params::service_manage,
  Integer[1,65535] $console_port               = $epics_gateway::params::console_port,
  Array[String] $client_ip                     = [],
  Integer[1,65535] $server_port                = $epics_gateway::params::server_port,
  Integer[1,65535] $client_port                = $epics_gateway::params::client_port,
  Array[String] $ignore_ips                    = [],
  Optional[Boolean] $cas_beacon_auto_addr_list = undef,
  Array[String] $cas_beacon_addr_list          = [],
  Hash[String, String] $env_vars               = {},
  String $gw_params                            = $epics_gateway::params::gw_params,
  String $home_dir                             = "/var/lib/${name}",
  String $pv_list                              = "/etc/epics/cagateway/${name}/pvlist",
  String $access_file                          = "/etc/epics/cagateway/${name}/access",
  String $command_file                         = "/etc/epics/cagateway/${name}/command",
  String $log_file                             = "/var/log/cagateway/${name}.log",
  Boolean $archive                             = $epics_gateway::params::archive,
  Boolean $no_cache                            = $epics_gateway::params::no_cache,
  Boolean $caputlog                            = $epics_gateway::params::caputlog,
  String $caputlog_host                        = $epics_gateway::params::caputlog_host,
  Integer[1,65535] $caputlog_port              = $epics_gateway::params::caputlog_port,
  String $prefix                               = $epics_gateway::params::prefix,
  Integer $debug                               = $epics_gateway::params::debug,
) {
  validate_absolute_path($home_dir)
  validate_hash($env_vars)

  if !($service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if !is_ip_address($server_ip) {
    fail('server_ip is not a valid ip address')
  }

  if $cas_beacon_auto_addr_list != undef {
    $cas_beacon_auto_list_str = $cas_beacon_auto_addr_list ? {
      true  => 'YES',
      false => 'NO',
    }
    $env_vars2 = merge($env_vars, {'EPICS_CAS_BEACON_AUTO_ADDR_LIST' => $cas_beacon_auto_list_str})
  } else {
    $env_vars2 = $env_vars
  }

  if $cas_beacon_addr_list {
    $real_env_vars = merge($env_vars2, {'EPICS_CAS_BEACON_ADDR_LIST' => join($cas_beacon_addr_list, ' ')})
  } else {
    $real_env_vars = $env_vars2
  }

  file { "/etc/systemd/system/${name}.service":
    ensure  => file,
    content => template("${module_name}/etc/systemd/system/cagateway.service"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['reload systemd configuration'],
  }

  file { $home_dir:
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
      name       => $name,
      require    => File[$home_dir],
      subscribe  => [
        Exec['reload systemd configuration'],
      ],
    }
  }
}
