# === Define: windows_python::windows_service
#
#  Define responsible of defining Windows services based on pyhtno code. It uses
#  win32service functionality to make it work.
#
# === Parameters
#
# [*name*]
#   Name of the service. Defaults to the title of the resource.
# [*display_name*]
#   Display name of the service. Defaults to the name of the service.
# [*description*]
#   A description of the service.
# [*arguments*]
#   String containing the arguments to pass to the python script.
# [*script*]
#   Python script that will be called by the service.
# == Examples
#
#  windows_python::windows_service { 'nova-compute':
#    ensure      => present, 
#    description => 'OpenStack Nova compute service for Hyper-V',
#    arguments   => '--config-file=C:\OpenStack\etc\nova.conf',
#    script      => 'C:\OpenStack\scripts\NovaComputeWindowsService.NovaComputeWindowsService',
#  }
#
# == Authors
#
define windows_python::windows_service (
  $display_name = $name,
  $description  = "",
  $arguments    = "",
  $ensure       = present,
  $script,
){
  $full_command = "C:\\Python27\\lib\\site-packages\\win32\\PythonService.exe ${arguments}"

  windows_common::configuration::service { ${name}:
    display     => $display_name,
    description => $description,
    binpath     => $full_command, 
  }

  registry_key { "HKLM\\System\\CurrentControlSet\\Services\\${name}\\PythonClass":
    ensure  => $ensure,
    require => Windows_common::Configuration::Service[${name}],
  }

  registry_value { "HKLM\\System\\CurrentControlSet\\Services\\${name}\\PythonClass\\":
    ensure  => $ensure,
    type    => string,
    data    => $script,
    require => Registry_key["HKLM\\System\\CurrentControlSet\\Services\\${name}\\PythonClass"],
  }
}
