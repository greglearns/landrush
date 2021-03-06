module Landrush
  class Config < Vagrant.plugin('2', :config)
    attr_accessor :hosts

    def initialize
      @hosts = {}
      @enabled = false
    end

    def enable(enabled=true)
      @enabled = true
    end

    def disable
      @enabled = false
    end

    def enabled?
      @enabled
    end

    def host(hostname, ip_address)
      @hosts[hostname] = ip_address
    end

    def merge(other)
      super.tap do |result|
        result.hosts = @hosts.merge(other.hosts)
      end
    end

    def validate(machine)
      if @enabled
        unless Util.hostname(machine).to_s.length > 0
          return { 'landrush' => ['you must specify a hostname so we can make a DNS entry for it'] }
        end
        unless Util.ip_address(machine)
          return { 'landrush' => ['you must specify a private network or else DNS makes no sense'] }
        end
      end
      {}
    end
  end
end
