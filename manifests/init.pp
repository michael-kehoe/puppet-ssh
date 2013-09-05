class sshserver ($ssh_port = 'undef',
	$ssh_listenaddress = 'undef',
	$ssh_protocol = 'undef',
	$ssh_hostkey = 'undef',
	$ssh_useprivilegeseparation = 'undef',
	$ssh_keyregenerationinterval = 'undef',
	$ssh_serverkeybits = 'undef',
	$ssh_syslogfacility = 'undef',
	$ssh_loglevel = 'undef',
	$ssh_logingracetime = 'undef',
	$ssh_permitrootlogin = 'undef',
	$ssh_strictmodes = 'undef',
	$ssh_rsaauthentication = 'undef',
	$ssh_pubkeyauthentication = 'undef',
	$ssh_authorizedkeysfile = 'undef',
	$ssh_ignorerhosts = 'undef',
	$ssh_rhostsrsaauthentication = 'undef',
	$ssh_hostbasedauthentication = 'undef',
	$ssh_ignoreuserknownhosts = 'undef',
	$ssh_permitemptypasswords = 'undef',
	$ssh_challengeresponseauthentication = 'undef',
	$ssh_passwordauthentication = 'undef',
	$ssh_kerberosauthentication = 'undef',
	$ssh_kerberosgetafstoken = 'undef',
	$ssh_kerberosorlocalpasswd = 'undef',
	$ssh_kerberosticketcleanup = 'undef',
	$ssh_gssapiauthentication = 'undef',
	$ssh_gssapicleanupcredentials = 'undef',
	$ssh_x11forwarding = 'undef',
	$ssh_x11displayoffset = 'undef',
	$ssh_printmotd = 'undef',
	$ssh_printlastlog = 'undef',
	$ssh_tcpkeepalive = 'undef',
	$ssh_uselogin = 'undef',
	$ssh_MaxStartups = 'undef',
	$ssh_banner = 'undef',
	$ssh_acceptenv = 'undef',
	$ssh_subsystem = 'undef',
	$ssh_usepam = 'undef') {

	case $operatingsystem {
		darwin: { $sshd_service = "com.openssh.sshd" }
		ubuntu: { $sshd_service = "ssh" }
		default: { $sshd_service = "sshd" }
	}

	package { 'openssh-server':
                ensure => installed,
        }
	
	package { 'openssh-blacklist':
		ensure => installed,
	}

   	file { "sshd_config":
       		path   => "/etc/ssh/sshd_config",
       		owner  => root,
       		group  => root,
       		mode   => 600,
       		content => template("sshserver/sshd_conf.erb"),
       		require => Package['openssh-server'],
		notify => Service[$sshd_service];
	}
   	
	file { "banner": 
		path => "/etc/ssh/banner",
		owner  => root,
                group  => root,
                mode   => 600,
		require => Package['openssh-server'],
                notify => Service[$sshd_service],
		source => "puppet:///modules/sshserver/banner",

	}
	
	service { "$sshd_service":
       		ensure => running,
       		enable => true,
		hasstatus => true,
		hasrestart => true,
	}
}
	
