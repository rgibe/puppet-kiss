class kiss::install inherits kiss {

  # OS Family Case
  ################

  case $::osfamily {
    'Debian': {
      # Fix update with apt::update doesn't work
      exec { 'apt-update':
        command => "/usr/bin/apt-get update"
      }
      package { $pkg_list:
        ensure => present,
        require  => Exec['apt-update'],
      }
    }
    'RedHat': {
      package { $pkg_list:
        ensure => present,
      }
      package { epel-release: # Only Cent0S
        ensure => present,
      }
    }
  }
 
}
