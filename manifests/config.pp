class epics_gateway::config() {
  user { 'cagateway':
    ensure => present,
    system => true,
    require => Class['::epics_gateway::install'],
  }

  file { '/var/log/cagateway':
    ensure => directory,
    owner  => 'cagateway',
    mode   => '0755',
  }
}