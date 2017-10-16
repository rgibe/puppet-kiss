# == Class: kiss

class kiss () inherits kiss::params {

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

  contain kiss::install
  contain kiss::config

  Class['::kiss::install']
  -> Class['::kiss::config']

}
