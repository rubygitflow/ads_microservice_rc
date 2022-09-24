# frozen_string_literal: true
module Concerns
  module ApiErrors
    def error_response(error_messages, meta: {})
      errors = case error_messages
      when Sequel::Model
        ErrorSerializer.from_model(error_messages)
      else
        ErrorSerializer.from_messages(error_messages, meta: meta)
      end

      errors
    end
  end
end
