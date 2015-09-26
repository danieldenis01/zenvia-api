module Zenvia
  class Sms
    attr_accessor :username, :password, :aggregate_id, :from, :to, :message, :schedule, :message_id, :callback_option

    def initialize(params)
      self.to = params[:to]
      self.message = params[:message]
      self.schedule = params[:schedule]
      self.message_id = params[:message_id]
      self.from = params[:from] || Zenvia.config.from
      self.callback_option = params[:callback_option] || "NONE"
      self.username = params[:username] || Zenvia.config.account
      self.password = params[:password] || Zenvia.config.password
    end

    def send
      request.send post_params
    end

    private

    def post_params
      body = {
        id: message_id,
        from: from,
        to: to,
        msg: message,
        schedule: schedule,
        callbackOption: callback_option,
        aggregateId: aggregate_id
      }
      body.delete_if { |k,v| v.nil? }

      {body: {sendSmsRequest: body}.to_json}
    end

    def request
      @request ||= Request.new(self.username, self.password)
    end
  end
end
