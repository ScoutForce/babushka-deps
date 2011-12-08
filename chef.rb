dep('bootstrap chef solo'){
  define_var(:chef_version, :defailt => "0.10.4", :message => "What version of Chef do you want to install?")

  setup {
    set :server_install, false
  }

  requires [
    'system',
    'hostname',
    'ruby',
    'chef install dependencies.managed',
    'rubygems',
    'rubygems with no docs',
    'chef gems',
    'chef solo configuration'
  ]
}

dep('chef install dependencies.managed') {
  installs %w[build-essential wget ssl-cert]
  provides %w[wget make gcc]
}

dep('rubygems with no docs') {
  met? {
    File.exists?("/etc/gemrc") &&
    !sudo('cat /etc/gemrc').split("\n").grep(/(^gem:)/).empty?
  }

  meet {
    shell('echo "gem: --no-ri --no-rdoc" > /etc/gemrc')
  }
}

dep('chef gems', :chef_version) {
  requires ['chef.gem'.with(chef_version), 'ohai.gem']
}

dep('chef.gem', :chef_version){
  installs "chef #{var(:chef_version, :default => '0.10.4')}"
  provides 'chef-client'
}

dep('ohai.gem') {
  installs 'ohai'
}

dep('chef solo configuration') {
  met?{ File.exists?("/etc/chef/solo.rb") }
  meet {
    shell("mkdir -p /etc/chef")
    render_erb 'chef/solo.rb.erb', :to => '/etc/chef/solo.rb', :perms => '755'
  }
}
