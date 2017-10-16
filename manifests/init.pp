# == Class: puppet-kiss

class puppet-kiss () inherits puppet-kiss::params {

  # Supported OS
  ##############

  if ! ($::operatingsystem in [ 'Debian', 'Ubuntu', 'CentOS' ]) {
    fail("Not Tested on: $::operatingsystem")
  }
 
  # Required Modules here
  #######################

  # include tomcat    # automatically included when used
  # include logrotate # automatically included when used
  class { 'apache':
    default_vhost => false,
  }

  contain puppet-kiss::install
  contain puppet-kiss::config

  Class['::puppet-kiss::install']
  -> Class['::puppet-kiss::config']

}
