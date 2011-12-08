dep 'system' do
  requires 'set.locale', 'hostname', 'secured ssh logins', 'lax host key checking', 'admins can sudo', 'tmp cleaning grace period', 'core software'
  requires 'bad certificates removed' if Babushka::Base.host.linux?
  setup {
    unmeetable "This dep has to be run as root." unless shell('whoami') == 'root'
  }
end

dep 'user setup', :username, :key do
  username.default(shell('whoami'))
  requires 'dot files'.with(username), 'passwordless ssh logins'.with(username, key), 'public key', 'zsh'.with(username)
end

dep 'core software' do
  requires {

  }
end
