# Zartan::Client

Ruby client for [Zartan](https://github.com/Raybeam/zartan/)

## Installation

Add this line to your application's Gemfile:

    gem 'zartan-client', git: 'https://github.com/Raybeam/zartan-client.git'

And then execute:

    $ bundle

## Usage

```ruby
require 'zartan/client'

# Create a client object
client = Zartan::Client.new(host: 'http://ZARTAN_HOST:ZARTAN_PORT', api_key: 'YOUR-API-KEY')

# Construct a new site object
site = client.sites[SITE_NAME]

# Get a new proxy for the site
proxy = site.get_proxy

# Get the proxy's info
puts "Proxy #{proxy.id} (#{proxy.host}:#{proxy.port})"

# Report the proxy's performace on that site
proxy.report_success
proxy.report_failure
```
