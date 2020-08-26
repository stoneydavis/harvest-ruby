# frozen_string_literal: true

module Harvest
  # @param name [string]
  #   Name of the message recipient.
  # @param email [string]
  #   Email of the message recipient.
  MessageRecipient = Struct.new(
    :name,
    :email,
    keyword_init: true
  )
end
