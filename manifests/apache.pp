class kiss::apache inherits kiss {

  #notify { "Apache Name: $apache_name": }
  apache::mod { 'headers': }
  apache::mod { 'proxy_ajp': }

  if $::osfamily == 'RedHat' {
    # Fix problem loading Apache Modules
    exec { 'selinux-permessive':
        command => "/sbin/setenforce 0 \
                   && /usr/bin/touch /root/.puppet-selinux-permessive_ok",
        creates  => "/root/.puppet-selinux-permessive_ok",
    }
  }

  file { 
     "/etc/$apache_name/ssl":
       require => Class[ apache ],
       ensure => directory;
  }

  # Create Apache2 Instances
  $apache_instances = lookup('apache_instances')
  if !empty($apache_instances) {
    create_resources('kiss::define::apache_instance', $apache_instances)
  }

}
