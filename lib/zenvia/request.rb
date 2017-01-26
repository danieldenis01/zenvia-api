module Zenvia
  class Request
    include HTTParty

    base_uri 'https://api-rest.zenvia360.com.br/services/'
    SEND_PATH = "/send-sms"

    attr_reader :default_options, :params, :response

    def initialize(username, password)
      @default_options = {
        basic_auth: { username: username, password: password },
        headers: {"Content-Type" => "application/json", "Accept" => "application/json"}
      }
    end

    def perform(options)
      options.merge!(default_options)
      @response = self.class.post(SEND_PATH, options)
      self.response.body
    end

    private

    def parse_response
      JSON.parse self.response.body
    end
  end
end
