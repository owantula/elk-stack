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
  new_hostname => 'elasticsearch',
}

class { 'elastic_stack::repo':
  version => 8
}

class { 'elasticsearch':
  config => {
    'network.host'         => '0.0.0.0',
    'discovery.seed_hosts' => ['localhost'],
    'cluster.initial_master_nodes' => ['elasticsearch'],
    'xpack.security.enabled' => false,
    'xpack.security.transport.ssl.enabled' => false,
    'xpack.security.http.ssl.enabled' => false
  }

}
