# slurm/workernode/setup.pp
#
# Creates folders/logfiles and installs packages specific to workernode
#
# @param slurmd_spool_dir Fully qualified pathname of a directory into which the Slurm deamon, slurmd, saves its state
# @param slurmd_log_file Fully qualified pathname of a file into which the slurmd daemon's logs are written
# @param packages Packages to install
#
# version 20170816
#
# Copyright (c) CERN, 2016-2017
# Authors: - Philippe Ganz <phganz@cern.ch>
#          - Carolina Lindqvist <calindqv@cern.ch>
#          - Pablo Llopis <pablo.llopis@cern.ch>
# License: GNU GPL v3 or later.
#

class slurm::workernode::setup (
  String $slurmd_spool_dir = $slurm::config::slurmd_spool_dir,
  Optional[String] $slurmd_log_file = $slurm::config::slurmd_log_file,
  Array[String] $packages = [
    'slurm-perlapi',
    'slurm-torque',
  ],
) {

  ensure_packages($packages, {'ensure' => $slurm::setup::slurm_version})

  file{ dirtree($slurmd_spool_dir, $slurmd_spool_dir) :
    ensure  => directory,
  }
  -> file{ 'slurmd spool folder':
    ensure => directory,
    path   => $slurmd_spool_dir,
    group  => 'slurm',
    mode   => '1755',
    owner  => 'slurm',
  }

  if ($slurmd_log_file != undef) {
    file{ dirtree($slurmd_log_file, $slurmd_log_file) :
      ensure  => directory,
    }
    -> file{ 'slurmd log':
      ensure => file,
      path   => $slurmd_log_file,
      group  => 'slurm',
      mode   => '0600',
      owner  => 'slurm',
    }
    -> logrotate::file{ 'slurmd':
      log     => $slurmd_log_file,
      options => ['weekly','copytruncate','rotate 26','compress'],
    }
  }
}
