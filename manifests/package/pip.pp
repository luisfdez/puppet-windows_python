define windows_python::package::pip (
  $source     = undef,
  $version    = latest,
){
  package { $name:
    source   => $source,
    ensure   => $version,
    provider => pip,
  }
}
