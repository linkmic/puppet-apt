# Define: apt::repository
#
# Add repository to /etc/apt/sources.list.d
#
# Usage:
#  apt::repository { "name":
#      url => 'repository url',
#      distro => 'distrib name',
#      repository => 'repository name(s)'
#      source => false
#  }
#
# For example, to add the standard Ubuntu Lucid repository, you can use
#
#   apt::repository { "ubuntu":
#      url        => "http://it.archive.ubuntu.com/ubuntu/",
#      distro     => 'lucid',
#      repository => 'main restricted',
#   }
# This will make the file /etc/apt/sources.list.d/ubuntu.list
# with content:
#
#   deb http://it.archive.ubuntu.com/ubuntu/ lucid main restricted
#
# If you have specified the source => true (the default is false), the line
# was:
#
#   deb-src http://it.archive.ubuntu.com/ubuntu/ lucid main restricted
#
define apt::repository (
    $url,
    $distro,
    $repository,
    $source=false,
    $require=undef
) {

  include apt

  # Create repository file
  file { "${name}.list":
    path    => "/etc/apt/sources.list.d/${name}.list",
    mode    => '644',
    owner   => 'root',
    group   => 'root',
    ensure  => present,
    content => template('apt/repository.list.erb'),
    notify  => Exec['aptget_update'],
    before  => Exec['aptget_update'],
  }

  if $require {
      File["${name}.list"] {
             require => [ $require, File['/etc/apt/sources.list.d'] ]
     }
  } else {
      File["${name}.list"] {
             require => File['/etc/apt/sources.list.d']
      }
  }

  Exec["aptget_update"] -> Package <||>
}

