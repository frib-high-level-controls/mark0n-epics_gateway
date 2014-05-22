# Configure all non-instance specific things.
#
class epics_gateway::config() {
  file { "/etc/init.d/cagateway":
    ensure => file,
    source => "puppet:///modules/${module_name}/etc/init.d/cagateway",
    owner  => 'root',
    mode   => '0755',
  }

  user { 'cagateway':
    ensure  => present,
    system  => true,
    require => Class['::epics_gateway::install'],
  }

  file { '/var/log/cagateway':
    ensure => directory,
    owner  => 'cagateway',
    mode   => '0755',
  }
}