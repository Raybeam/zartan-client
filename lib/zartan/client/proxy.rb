module Zartan
  class Proxy
    attr_reader :id
    attr_reader :host
    attr_reader :port
    attr_reader :username
    attr_reader :password
    
    def initialize(site:, id:, host:, port:, username:, password:)
      @site = site
      @id = id
      @host = host
      @port = port
      @username = username
      @password = password
    end
    
    def report_success
      report 'succeeded'
    end
    
    def report_failure(reason = nil)
      opts = if reason then { reason: reason } else {} end
      report 'failed', opts
    end
    
    private
    def report(status, opts = {})
      @site.client.report(@site.name, @id, status, opts)
    end
  end
end