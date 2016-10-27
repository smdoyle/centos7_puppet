class docker {

	package { 'lvm2':
		ensure => 'absent',
		}

	file { "/etc/yum.repos.d/docker.repo":
		mode => '0644',
		owner => 'root',
		group => 'root',
		source => "file:///vagrant/files/etc/yum.repos.d/docker.repo",
		}
	package { 'docker-engine':
		ensure => 'latest',
		}
	service { 'docker':
		ensure => 'running',
		enable => 'true',
		}
	user { 'vagrant':
		ensure => present,
		groups => [ 'docker'],
		} # this really should be moved to a user module for the vagrant user
	File['/etc/yum.repos.d/docker.repo'] -> Package['lvm2'] -> Package['docker-engine'] -> Service['docker']
}

class devtools {

	#wrap this up in a custom module later
	package { 'rspec-puppet':
		ensure => 'latest',
		provider => 'gem',
	}
	package { 'puppet-lint':
		ensure => 'latest',
		provider => 'gem',
	}

	# local package for module testing
	package { 'mariadb-devel' :
		ensure => 'installed',
	}
	package { 'mariadb-libs' :
		ensure => 'installed',
	}
	package { 'gcc-c++' :
		ensure => 'latest',
	}
	package { 'tree':
		ensure => 'latest',
	}
	package { 'git':
		ensure => 'latest',
	}
}

node 'default' {

	class { 'java': 
	}
	class { 'ruby':
		gems_version => 'latest',
	}
	class { 'ruby::dev':
		rake_ensure => 'installed',
		bundler_ensure => 'installed',
	}

	file { "/etc/yum.conf":
		mode => '0644',
		owner => 'root',
		group => 'root',
		source => "file:///vagrant/files/etc/yum.conf",
	}

	file { "/etc/sudoers":
		mode => '0440',
		owner => 'root',
		group => 'root',
		source => "file:///vagrant/files/etc/sudoers",
	}

	class { 'docker': }
	class { 'devtools': }
}
