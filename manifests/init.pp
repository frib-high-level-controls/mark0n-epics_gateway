# Configure the system-wide stuff like installing packages etc.
#
class epics_gateway(
  String $package_name    = $epics_gateway::params::package_name,
  String $package_ensure  = $epics_gateway::params::package_ensure,
  Boolean $service_enable = $epics_gateway::params::service_enable,
  String $service_ensure  = $epics_gateway::params::service_ensure,
  String $user            = $epics_gateway::params::user,
) inherits epics_gateway::params {
  class { '::epics_gateway::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
  }

  exec { 'reload systemd configuration':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'epics_gateway::begin': }
    -> Class['::epics_gateway::install']
    -> class { '::epics_gateway::config': }
    -> anchor { 'epics_gateway::end': }
}
