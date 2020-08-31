# frozen_string_literal: true

module Harvest
  # @param name [string]
  #   Name of the message recipient.
  # @param email [string]
  #   Email of the message recipient.
  Struct.new(
    'MessageRecipient',
    :name,
    :email,
    keyword_init: true
  )
end
