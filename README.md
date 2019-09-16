This Puppet module installs and configures the EPICS Channel Access Gateway.
The gateway is run in 'procServ' to ease maintenance. The gateway can be
started/stopped as a systemd service.

Note that there is a non-instance specific part which is only needed once for
each host acting as a Channel Access gateway and an instance-specific part
which is needed for each instance of the gateway. The general part can be found
in class epics_gateway whereas epics_gateway::gateway needs to be instantiated
for each gateway instance that should be run on the managed machine.

Examples that require multiple gateway instances on a single machine include:

a) A gateway machine providing access to an accelerator network as well as to
   an experimental network from the office network (three networks).
b) A gateway machine that provides access back and forth between an
   accelerator network and an experimental network (thus acting as a forward
   and reverse gateway).

# Examples

Make PVs from 192.168.1.xxx and 192.168.2.xxx available on 192.168.3.xxx:
```
include 'epics_gateway'

vcsrepo { '/etc/epics/cagateway-192.168.1.xxx':
  ...
}

vcsrepo { '/etc/epics/cagateway-192.168.2.xxx':
  ...
}

epics_gateway::gateway { '192.168.1.xxx':
  server_ip => '192.168.3.1',
  client_ip => '192.168.1.255',
  require   => Package['ioclogserver'],
  subscribe => Vcsrepo['/etc/epics/cagateway-192.168.1.xxx'],
}

epics_gateway::gateway { '192.168.2.xxx':
  server_ip => '192.168.3.1',
  client_ip => '192.168.2.255',
  require   => Package['ioclogserver'],
  subscribe => Vcsrepo['/etc/epics/cagateway-192.168.2.xxx'],
}
```

# Contact

Author: Martin Konrad <konrad at frib.msu.edu>