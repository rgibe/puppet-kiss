## Overview

If you need to configure a service with: **Apache** and **Tomcat**
you may consider this module like good "**starting point**".

The basic idea of this project is to *provide a skeleton example and a way* 
to easy configure a service in an "atomic" and "self-contained" module.  

Why KISS? ... because I tried to keep it as simple as I can.

## Prerequisite

- puppet module install puppetlabs-apache
- puppet module install puppetlabs-tomcat
- puppet module install yo61-logrotate

## Compatible with

- Puppet >= 4.7.0 < 6.0.0
- Ubuntu, Debian, CentOS

## Usage

~~~
---
apache_instances:
  'test1.domain.local':
    ajp_port: 8011

tomcat_instances:
  'test1':
    port: '8001'
    java_home: '/usr/lib/jvm/jre-1.8.0-openjdk'
~~~

