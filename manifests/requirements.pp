define windows_python::requirements (
  $requirements = $name,
  $virtualenv   = 'system',
  $proxy        = false,
  $src          = false,
  $environment  = [],
  $forceupdate  = false,
) {

  $pip_env = $virtualenv ? {
    'system' => 'pip.exe',
    default  => "${virtualenv}/Scripts/pip.exe",
  }

  $proxy_flag = $proxy ? {
    false    => '',
    default  => "--proxy=${proxy}",
  }

  $src_flag = $src ? {
    false   => '',
    default => "--src=${src}",
  }

  # This will ensure multiple python::virtualenv definitions can share the
  # the same requirements file.
  if !defined(File[$requirements]) {
    file { $requirements:
      ensure  => present,
      audit   => content,
      replace => false,
      content => '# Puppet will install and/or update pip packages listed here',
    }
  }

  exec { "python_requirements${name}":
    command     => "${pip_env} install ${proxy_flag} ${src_flag} -r ${requirements}",
    refreshonly => !$forceupdate,
    timeout     => 1800,
    subscribe   => File[$requirements],
    environment => $environment,
    path        => $::path,
  }

}
