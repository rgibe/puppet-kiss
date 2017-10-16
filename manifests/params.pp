class puppet-kiss::params {

  if $::osfamily == 'RedHat' {
    $apache_name = 'httpd'
    $pkg_list = ['tcpdump', 'mlocate', 'tree', 'bind-utils', 'wget', 'curl', 'java-1.8.0-openjdk', 'net-tools']
  } 
  elsif $::osfamily == 'Debian' {
    $apache_name = 'apache2'
    $pkg_list = ['tcpdump', 'locate', 'tree', 'dnsutils', 'wget', 'curl', 'openjdk-8-jdk']
  } 
  else { fail("Unsupported osfamily: ${::osfamily}") }

}

