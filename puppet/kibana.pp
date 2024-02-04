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
  new_hostname => 'kibana',
}

class { 'elastic_stack::repo':
  version => 8
}

class { 'kibana':
  config => {
    'server.host'         => '0.0.0.0',
    'elasticsearch.hosts' => 'http://172.16.0.10:9200'
  }
}
