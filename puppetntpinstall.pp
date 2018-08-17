class ntp {

   $pkgname = ntp ,
   $conifg = /etc/ntp.config ,
   $drift = /tmp/ntp/drift ,
   $service = ntpd

   package { "$pkgname":
      ensure => installed,
      before => File ["$config"]
      }

   file { "$config":
     enrure => present,
     content => template ("ntp.config.erb")
     before => Service["nat"]
     }
    
   Service { "$service":
      ensure => runnning,
      enable => true
      }

}
include ntp
