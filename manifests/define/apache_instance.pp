define kiss::define::apache_instance (
  $ajp_port = '8011',
) {

  # Variables
  #notify { "Scope Apache Name: $kiss::apache_name": }
  $_apache_name = "$kiss::apache_name"
  $docroot = '/production/htdocs'

  # Self Signed SSL CERT
  $ssl_path="/etc/$_apache_name/ssl"
  exec { "cert_ssl_${name}":
    command => "/usr/bin/openssl req -x509 -nodes -days 3652 -newkey rsa:2048 -subj '/CN=${name}' -out $ssl_path/${name}.pem -keyout $ssl_path/${name}.key",
    creates => "${ssl_path}/${name}.pem",
    require => File["/etc/$_apache_name/ssl"],
    logoutput => true,
  }

  # Apache VHs config
  ##################

  apache::vhost { "${name}-http":
    port    => 80,
    servername => "${name}",
    serveradmin => "webmaster@${name}",
    docroot => "${docroot}",
    redirect_status => 'permanent',
    redirect_dest   => "https://${name}/"
  }

  apache::vhost { "${name}-https":
    port    => 443,
    servername => "${name}",
    serveradmin => "webmaster@${name}",
    docroot => "${docroot}",
  
    ssl => true,
    ssl_cert => "$ssl_path/${name}.pem",
    ssl_key => "$ssl_path/${name}.key",
    #ssl_chain => "$ssl_path/${name}.chain",
    ssl_options => [ '+StrictRequire', '+StdEnvVars' ],
    ssl_verify_client => 'none',
    ssl_verify_depth => 1,
    ssl_cipher => 'HIGH:MEDIUM:!aNULL:!MD5:!RC4:!DH',
    ssl_protocol => 'all -SSLv2 -SSLv3',

    directories => [
      {
        path => "${docroot}",
        options => 'none',
        require => 'all granted',
      },
    ],
    rewrites => [
      {
        comment      => 'Redirect Base',
        rewrite_rule => ['^/$ /hello/ [L,R]'],
      },
    ],
    # The AJP request includes the original host header given to the proxy so no rewriting is necessary
    proxy_pass => [
      { 'path' => '/hello', 'url' => "ajp://localhost:${ajp_port}/hello" },
    ],
  }

}
