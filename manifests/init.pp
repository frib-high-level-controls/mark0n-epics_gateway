# == Class: epics_gateway
#
# Installs and configures the EPICS Channel Access Gateway
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { epics_gateway:
#  }
#
# === Authors
#
# Martin Konrad <konrad@frib.msu.edu>
#
# === Copyright
#
# Copyright 2014 Facility for Rare Isotope Beams (FRIB),
# Michigan State University, East-Lansing, MI, USA
#
class epics_gateway(
  $package_name   = $epics_gateway::params::package_name,
  $package_ensure = $epics_gateway::params::package_ensure,
  $service_enable = $epics_gateway::params::service_enable,
  $service_ensure = $epics_gateway::params::service_ensure,
  $service_name   = $epics_gateway::params::service_name,
) inherits epics_gateway::params {
  class { '::epics_gateway::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'epics_gateway::begin': } ->
  Class['::epics_gateway::install'] ->
  anchor { 'epics_gateway::end': }
}
