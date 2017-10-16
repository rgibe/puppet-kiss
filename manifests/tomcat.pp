class kiss::tomcat inherits kiss {

  tomcat::install { 'default':
    source_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.81/bin/apache-tomcat-7.0.81.tar.gz',
    catalina_home => '/production/tomcat7/source',
  }

  file {
    ['/production/tomcat7',
     '/production/tomcat7/temp',
     '/production/tomcat7/memdump',
     '/production/tomcat7/war',
     '/production/tomcat7/instances',]:
       owner => 'tomcat',
       group => 'tomcat',
       ensure => directory;
  }

  # Create Tomcat Instances
  $tomcat_instances = lookup('tomcat_instances')
  if !empty($tomcat_instances) {
    create_resources('kiss::define::tomcat_instance', $tomcat_instances)
  }

}
