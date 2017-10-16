class kiss::config inherits kiss {

  file { 
    ['/production',
     '/production/htdocs',]:
       ensure => directory;
  }

  # Include specific configuration manifest
  #########################################

  class{'kiss::tomcat': }
  class{'kiss::apache': }
  class{'kiss::logrotate': }
 
}
