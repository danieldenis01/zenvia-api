module Zenvia
  class Request
    include HTTParty

    base_uri 'https://api-rest.zenvia360.com.br/services/'
    SEND_PATH = "/send-sms"
    GET_STATUS_PATH = "/get-sms-status"

    attr_reader :default_options, :params, :response, :username, :password

    def initialize(username, password)
      @username = username
      @password = password
      @default_options = {
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "Authorization" => "Basic #{basic_auth_encoded}"
        }
      }
    end

    def perform(options)
      options.merge!(default_options)
      @response = self.class.post(SEND_PATH, options)
      parse_response
    end

    def check_status(sms_id)
      @response = self.class.get("#{GET_STATUS_PATH}/#{sms_id}")
      parse_response
    end

    def basic_auth_encoded
      Base64.encode64("#{username}:#{password}").gsub("\n", "")
    end

    private

    def parse_response
      JSON.parse self.response.body
    end
  end
end
