class puppet-kiss::config inherits puppet-kiss {

  file { 
    ['/production',
     '/production/htdocs',]:
       ensure => directory;
  }

  # Include specific configuration manifest
  #########################################

  class{'puppet-kiss::tomcat': }
  class{'puppet-kiss::apache': }
  class{'puppet-kiss::logrotate': }
 
}
