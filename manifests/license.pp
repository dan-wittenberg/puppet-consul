# == Class consul::license
#
# This class is meant to be called from consul
# It will apply the Enterprise License
#
# @summary Apply the Consul Enterprise license
#
# @example
#   include consul::license
class consul::license {

  if($consul::enterprise_license) {
    file { "${consul::config_dir}/consul_enterprise.hclic":
      ensure  => absent,
    }

    file { "${consul::data_dir}/consul_enterprise.hclic":
      ensure  => file,
      owner   => 'consul',
      group   => 'consul',
      mode    => '0400',
      content => $consul::enterprise_license,
    }

    exec { 'update-consul-license':
      path      => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
      command   => "consul license put @${consul::data_dir}/consul_enterprise.hclic",
      onlyif    => 'consul license get |grep "License ID: temporary"',
      logoutput => true,
      require   => File["${consul::data_dir}/consul_enterprise.hclic"],
    }
  }
}
