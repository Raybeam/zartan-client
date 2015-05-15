module Zartan
  class Site
    attr_reader :name
    attr_reader :client
    
    def initialize(client, name)
      @client = client
      @name = name
    end
    
    def get_proxy(opts = {})
      @client.max_proxy_retries.times do
        response = @client.get_proxy(@name, opts)
        
        if response['result'] == 'success'
          return Proxy.new(
            site: self,
            id: response['payload']['id'],
            host: response['payload']['host'],
            port: response['payload']['port']
          )
        else
          # response['status'] == 'please_retry'
          sleep response['interval'].to_i
        end
      end
      
      raise NoProxiesAvailable, "Failed to retrieve any proxies after retrying max_proxy_retries (#{@client.max_proxy_retries}) times."
    end
    
    class Factory
      def initialize(client)
        @client = client
      end
      
      def[](site_name)
        ::Zartan::Site.new(@client, site_name)
      end
    end
  end
end