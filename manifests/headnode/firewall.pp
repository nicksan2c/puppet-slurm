# slurm/headnode/firewall.pp
#
# Common firewall rules for the headnode
#
# version 20170301
#
# @param slurmctld_port
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::headnode::firewall (
  Integer $slurmctld_port = 6817,
) {

  firewall{ '200 open slurmctld port':
    action => 'accept',
    dport  => $slurmctld_port,
    proto  => 'tcp',
  }
}
