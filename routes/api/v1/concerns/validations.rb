module Concerns
  module Validations
    # class InvalidParams < StandardError; end

    def validate_with!(validation)
      result = validate_with(validation)
      # https://www.rubydoc.info/gems/roda/Roda/RodaPlugins/TypecastParams
      # (raise Roda::RodaPlugins::TypecastParams::Error) if result.failure? #  redundant condition
      result
    end

    def validate_with(validation)
      contract = validation.new
      # https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/TypecastParams.html
      contract.call(request.params['params'])
    end
  end
end
