# frozen_string_literal: true
require "dry/validation"

class AdParamsContract < Dry::Validation::Contract
  params do
    required(:ad).hash do
      required(:title).value(:string)
      required(:description).value(:string)
      required(:city).value(:string)
      required(:user_id).value(:integer)
    end
  end
end
