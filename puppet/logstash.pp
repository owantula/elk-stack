class change_hostname (
  String $new_hostname,
)
{

  file { '/etc/hostname':
    ensure  => file,
    content => "${new_hostname}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  exec { 'update_hostname':
    command     => "/bin/hostnamectl set-hostname ${new_hostname}",
    refreshonly => true,
    subscribe   => File['/etc/hostname'],
  }
}

class { 'change_hostname':
  new_hostname => 'logstash',
}

class { 'elastic_stack::repo':
  version => 8,
}

class { 'logstash':
}

logstash::configfile { 'forward_logs':
  content => template('/home/ubuntu/pipeplines/forward_logs'),
}
