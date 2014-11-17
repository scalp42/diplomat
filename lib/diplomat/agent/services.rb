require 'base64'
require 'faraday'

module Diplomat::Agent
  class Services < Diplomat::RestClient

    # Get all services
    # @return [OpenStruct] all data associated with the service
    def get
      ret = @conn.get "/v1/agent/services"
      return JSON.parse(ret.body)
    end

    # Register a service
    # @param service_id [String] the unique id of the service
    # @param name [String] the name
    # @param tags [Array] Arbitrary array of string
    # @param port [Integer] Integer service endpoint portnumber
    # @param check [Hash] only one of (Script and Interval) or TTL
    # @return [Boolean] Status code
    def register service_id, name, tags, port, check
      json = JSON.generate({
        "ID"    => service_id,
        "Name"  => name,
        "Tags"  => tags,
        "Port"  => port,
        "Check" => check
      })

      ret = @conn.put do |req|
        req.url "/v1/agent/service/register"
        req.body = json
      end
      return true if ret.status == 200
    end

    # Deregister a service
    # @param service_id [String] the unique id of the service
    # @return [Boolean] Status code
    def deregister service_id
      ret = @conn.get "/v1/agent/service/deregister/#{service_id}"
      return true if ret.status == 200
    end

    # @note This is sugar, see (#get)
    def self.get
      Diplomat::Agent::Services.new.get
    end

  end
end
