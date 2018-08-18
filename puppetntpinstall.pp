class ntp {

   $pkgname = ntp 
   $conifg = "/etc/ntp.conf" 
   $drift = "/var/lib/ntp1/drift" 
   $service = ntpd

   package { $pkgname:
      ensure => installed,
      before => File ["$config"]
      }

   file { $config:
     ensure => present,
     content => template ("/root/puppetcodes/DevOPs_Class/NTP/ntp.conf.erb")
     before => Service["$service"]
     }
    
   service { $service:
      ensure => runnning,
      enable => true
      }

}
include ntp
