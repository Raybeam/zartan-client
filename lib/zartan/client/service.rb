require 'uri'

module Zartan
  class Service
    ZERO_CLIENT_ID = "00000000-0000-0000-0000-000000000000"
    
    def initialize(host, api_key)
      @host = host
      @api_key = api_key
    end
    
    def authenticate_uri
      zartan_uri 'v2/authenticate', api_key: @api_key
    end
    
    def get_proxy_uri(site, opts = {})
      opts = { client_id: ZERO_CLIENT_ID }.merge(opts)
      zartan_uri 'v2/proxy_for', site, opts
    end
    
    def report_uri(site, proxy_id, status, opts = {})
      opts = { client_id: ZERO_CLIENT_ID }.merge(opts)
      unless %w(succeeded failed).include? status
        if status
          status = 'succeeded'
        else
          status = 'failed'
        end
      end
      
      zartan_uri 'v2/report', site, proxy_id, status, opts
    end
    
    private
    def zartan_uri(*parts)
      opts = parts.pop if parts.last.is_a? Hash
      uri = URI( File.join(@host, *parts) )
      uri.query = URI.encode_www_form opts if opts
      uri
    end
  end
end