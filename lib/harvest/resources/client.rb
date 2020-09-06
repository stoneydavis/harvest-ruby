# frozen_string_literal: true

module Harvest
  # @param id [Integer]
  #   Unique ID for the client.
  # @param name [String]
  #   A textual description of the client.
  # @param is_active [Boolean]
  #   Whether the client is active or archived.
  # @param address [String]
  #   The physical address for the client.
  # @param statement_key [String]
  #   Used to build a URL to your client's invoice dashboard:
  # https://{ACCOUNT_SUBDOMAIN}.harvestapp.com/client/invoices/{statement_key}
  # @param currency [String]
  #   The currency code associated with this client.
  # @param created_at [DateTime]
  #   Date and time the client was created.
  # @param updated_at [DateTime]
  #   Date and time the client was last updated.
  ResourceClient = Struct.new(
    'ResourceClient',
    :id,
    :name,
    :is_active,
    :address,
    :statement_key,
    :currency,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
