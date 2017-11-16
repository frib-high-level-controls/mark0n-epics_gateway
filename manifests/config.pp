# Configure all non-instance specific things.
#
class epics_gateway::config() {
  user { $epics_gateway::user:
    ensure  => present,
    system  => true,
    require => Class['::epics_gateway::install'],
  }

  file { '/var/log/cagateway':
    ensure => directory,
    owner  => $epics_gateway::user,
    mode   => '0755',
  }
}