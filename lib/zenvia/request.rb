module Zenvia
  class Request
    include HTTParty

    base_uri 'https://api-rest.zenvia360.com.br'
    SEND_PATH = "/services/send-sms"

    attr_reader :default_options, :params, :response

    def initialize(username, password)
      @default_options = {
        basic_auth: { username: username, password: password },
        headers: {"Content-Type" => "application/json", "Accept" => "application/json"}
      }
    end

    def send(options)
      options.merge!(default_options)
      @response = self.class.post(SEND_PATH, options)
      parse_response
    end

    private

    def parse_response
      debugger
      code, message = response.body.split " - "
      raise Error, message if code != "000"

      {code: code, message: message}
    end

    def parse_params
      {
        account:        Zenvia.config.account,
        code:           Zenvia.config.code,
        dispatch:       params[:dispatch],
        to:             params[:to],
        msg:            params[:message],
        id:             params[:id],
        callbackOption: params[:callback_option]
      }
    end
  end
end
