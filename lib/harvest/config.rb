# frozen_string_literal: true

module Harvest
  # @param domain [String] Harvest domain ex: https://company.harvestapp.com
  # @param account_id [Integer] Harvest Account id
  # @param personal_token [String] Harvest Personal token
  # @param admin_api [Boolean] Certain API Requests will fail if you are not 
  #                            an admin in Harvest. This helps set that
  #                            functionality to limit broken interfaces
  Struct.new(
    'Config',
    :domain,
    :account_id,
    :personal_token,
    keyword_init: true
  ) do
    def admin_api=(value: false)
      @admin_api ||= value
  end
end
