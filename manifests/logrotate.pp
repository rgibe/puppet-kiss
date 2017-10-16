class kiss::logrotate inherits kiss {

  logrotate::conf { '/etc/logrotate.conf':
    rotate       => 10,
    rotate_every => 'week',
    ifempty      => true,
    compress => true,
  }
  logrotate::rule { "$apache_name":
    path          => "/var/log/$apache_name/*.log",
    compress => true,   
    rotate        => 60,
    rotate_every => 'day',
    create => true,
    create_mode => '0644',
    dateext  => true,
    delaycompress => true,
    missingok => true,
    sharedscripts => true,
    postrotate    => "systemctl status $apache_name",
  }
 
}
