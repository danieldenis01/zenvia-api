module Zenvia
  class Request
    include HTTParty

    base_uri 'https://api-rest.zenvia360.com.br/services/'
    SEND_PATH = "/send-sms"

    attr_reader :default_options, :params, :response

    def initialize(username, password)
      @default_options = {
        basic_auth: { username: username, password: password }
      }
    end

    def perform(options)
      options.merge! default_options
      options.merge! headers: {"Content-Type" => "application/json", "Accept" => "application/json"}
      @response = self.class.post(SEND_PATH, options)
      parse_response
    end

    def check_sms_stauts(sms_id)
      options = default_options.dup
      options.merge! headers: {"Accept" => "application/json"}
      @response = self.class.get("/get-sms-status/#{sms_id}", options)
      parse_response
    end

    private

    def parse_response
      JSON.parse self.response.body
    end
  end
end
