class apt::repo::lenny-backports {

  #Add lenny-backports repository
  apt::key { "8347A27F": }
  
  apt::repository { "lenny-backports":
    url         => "http://backports.debian.org/debian-backports",
    distro      => "${::lsbdistcodename}-backports",
    repository  => "main",
    require     => Apt::Key["8347A27F"],
    source      => true
  }
}

