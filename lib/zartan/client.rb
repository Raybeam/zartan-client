require 'zartan/client/version'
require 'zartan/client/service'
require 'zartan/client/site'
require 'zartan/client/proxy'

require 'mechanize'
require 'json'

module Zartan
  class Client
    attr_accessor :max_proxy_retries
    
    def initialize(host:, api_key:, max_auth_retries: 3, max_proxy_retries: 5)
      @service = Zartan::Service.new(host, api_key)
      @client_id = Zartan::Service::ZERO_CLIENT_ID
      @max_auth_retries = max_auth_retries
      @max_proxy_retries = max_proxy_retries
    end
    
    def authenticate
      response = get @service.authenticate_uri
      if response['result'] == 'success'
        @client_id = response['payload']['client_id']
        true
      else
        raise AuthenticationError, 'Invalid API Key'
      end
    end
    
    def get_proxy(site_name, opts = {})
      reauthenticating_if_necessary do
        response = get @service.get_proxy_uri(site_name, opts.merge(client_id: @client_id))
        if %w(success please_retry).include? response['result']
          response
        elsif is_client_id_error? response
          reauthenticate!
        else
          raise MalformedResponse, "Unexpected response: #{response.inspect}"
        end
      end
    end
    
    def report(site_name, proxy_id, status, opts = {})
      reauthenticating_if_necessary do
        response = post @service.report_uri(site_name, proxy_id, opts.merge(client_id: @client_id))
        if response['result'] == 'success'
          response
        elsif is_client_id_error? response
          reauthenticate!
        else
          raise MalformedResponse, "Unexpected response: #{response.inspect}"
        end
      end
    end
    
    def sites
      ::Zartan::Site::Factory.new(self)
    end
    

    MalformedResponse = Class.new(StandardError)
    AuthenticationError = Class.new(StandardError)
    
    
    private
    def get(uri)
      agent = Mechanize.new
      response = agent.get(uri)
      JSON.parse(response.body)
    end
    
    def post(uri)
      agent = Mechanize.new
      response = agent.post(uri)
      begin
        JSON.parse(response.body)
      rescue
        raise MalformedResponse, "Non-JSON response: #{response.body}"
      end
    end
    
    def is_client_id_error?(response)
      response['result'] == 'error' and response['reason'] == 'Unrecognized client id'
    end
    
    def reauthenticating_if_necessary(&block)
      @should_reauthenticate = false
      
      @max_auth_retries.times do
        result = yield
        
        if @should_reauthenticate
          authenticate
          @should_reauthenticate = false
        else
          return result
        end
      end
      
      raise AuthenticationError, "Failed to authenticate after max_auth_retries (#{@max_auth_retries}) attempts."
    end
    
    def reauthenticate!
      @should_reauthenticate = true
    end
  end
end
