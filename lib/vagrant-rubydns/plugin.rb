module VagrantRubydns
  class Plugin < Vagrant.plugin('2')
    name 'vagrant-rubydns'

    command 'rubydns' do
      require_relative 'command'
      Command
    end

    config 'rubydns' do
      require_relative 'config'
      Config
    end

    action_hook 'rubydns_setup', :machine_action_up do |hook|
      require_relative 'action/setup'
      require_relative 'action/redirect_dns'
      hook.before(VagrantPlugins::ProviderVirtualBox::Action::Boot, Action::Setup)
      hook.after(VagrantPlugins::ProviderVirtualBox::Action::Boot, Action::RedirectDns)
    end

    action_hook 'rubydns_teardown', :machine_action_halt do |hook|
      require_relative 'action/teardown'
      hook.after(Vagrant::Action::Builtin::GracefulHalt, Action::Teardown)
    end

    action_hook 'rubydns_teardown', :machine_action_destroy do |hook|
      require_relative 'action/teardown'
      hook.after(Vagrant::Action::Builtin::GracefulHalt, Action::Teardown)
    end
  end
end
