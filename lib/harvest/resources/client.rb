# frozen_string_literal: true

module Harvest
  # @param id [integer]
  #   Unique ID for the client.
  # @param name [string]
  #   A textual description of the client.
  # @param is_active [boolean]
  #   Whether the client is active or archived.
  # @param address [string]
  #   The physical address for the client.
  # @param statement_key [string]
  #   Used to build a URL to your client’s invoice dashboard:
  # https://{ACCOUNT_SUBDOMAIN}.harvestapp.com/client/invoices/{statement_key}
  # @param currency [string]
  #   The currency code associated with this client.
  # @param created_at [datetime]
  #   Date and time the client was created.
  # @param updated_at [datetime]
  #   Date and time the client was last updated.
  ResourceClient = Struct.new(
    :id,
    :name,
    :is_active,
    :address,
    :statement_key,
    :currency,
    :created_at,
    :updated_at
  ) do
  end

end
