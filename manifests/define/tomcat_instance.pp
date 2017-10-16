define puppet-kiss::define::tomcat_instance (
  $port = 8001,
  $jvm = 'jvm1a',
  $java_home = '/usr/lib/jvm/jdk1.8.0_131',
) {

  # Variables
  $home = '/production/tomcat7'
  $service_name = "tomcat-${name}"
  $pidfile = "${home}/temp/${service_name}.pid"
  $catalina_home = "${home}/source"
  $catalina_base = "${home}/instances/${name}"
  $instance_owner = 'tomcat'
  $instance_group = 'tomcat'

  $offset = Numeric( regsubst($port,'^\d+(\d{1})$','\1') ) 
  notify { "Get offset digits: ${offset}": }
  $http_port= 8080 + $offset
  $ajp_port= 8010 + $offset

  file { 
    "/etc/systemd/system/${service_name}.service": # for RH
      content => template('puppet-kiss/systemd-tomcat.erb'),
      owner   => root,
      group   => root,
      mode => '0644';
    "${catalina_base}/bin/setenv.sh":
      content => template('puppet-kiss/setenv.erb'),
      owner => $instance_owner,
      group => $instance_group,
      mode => '0744';
    "${catalina_base}/bin/appenv.sh":
      content => template('puppet-kiss/appenv.erb'),
      owner => $instance_owner,
      group => $instance_group,
      mode => '0744';
    "${catalina_base}/webapps/hello.war":
      source => 'puppet:///modules/puppet-kiss/hello.war',
      owner => $instance_owner,
      group => $instance_group;
  }

  tomcat::instance { "${name}":
    catalina_home => $catalina_home,
    catalina_base => $catalina_base,
    manage_service => false, # managed later with "tomcat::service"
    user => $instance_owner,
    group => $instance_group,
    require => Tomcat::Install['default'],
  }
  tomcat::config::server { "${name}-port":
    catalina_base => $catalina_base,
    port          => $port,
  }
  tomcat::config::server::connector { "${name}-http-default":
    catalina_base => $catalina_base,
    port          => '8080',
    protocol      => 'HTTP/1.1',
    connector_ensure => 'absent',
    before        => Tomcat::Service["${name}-service"],
  }
  tomcat::config::server::connector { "${name}-ajp-default":
    catalina_base => $catalina_base,
    port          => '8009',
    protocol      => 'AJP/1.3',
    connector_ensure => 'absent',
    before        => Tomcat::Service["${name}-service"],
  }
  tomcat::config::server::connector { "${name}-http":
    catalina_base => $catalina_base,
    port          => $http_port,
    protocol      => 'HTTP/1.1',
    before        => Tomcat::Service["${name}-service"],
  }
  tomcat::config::server::connector { "${name}-ajp":
    catalina_base => $catalina_base,
    port          => $ajp_port,
    protocol      => 'AJP/1.3',
    additional_attributes => {
          'URIEncoding' => 'UTF-8',
          'connectionTimeout' => '300000',
          'tomcatAuthentication' => 'false',
        },
    before        => Tomcat::Service["${name}-service"],
  }
  tomcat::config::server::engine { "${name}-engine":
    catalina_base => $catalina_base,
    engine_name   => "Catalina",
    default_host  => "localhost",
    jvm_route     => $jvm,
    before        => Tomcat::Service["${name}-service"],
    require => Tomcat::Config::Server::Connector["${name}-ajp"],
  }
  tomcat::config::context::manager { "${name}-context":
    catalina_base => $catalina_base,
    manager_classname => "org.apache.catalina.session.StandardManager",
    additional_attributes => { pathname => "",},
    before        => Tomcat::Service["${name}-service"],
    require => Tomcat::Config::Server::Engine["${name}-engine"],
  }
  tomcat::service { "${name}-service":
    catalina_base => $catalina_base,
    use_init     => true,
    service_name => $service_name,
    service_enable => true,
    service_ensure => running,
    subscribe => File["${catalina_base}/bin/setenv.sh"],
  }

#  notify { "Try me at http://127.0.0.1:${http_port}/hello": }

}
