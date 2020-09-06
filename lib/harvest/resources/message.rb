# frozen_string_literal: true

module Harvest
  # @param name [String]
  #   Name of the message recipient.
  # @param email [String]
  #   Email of the message recipient.
  MessageRecipient = Struct.new(
    'MessageRecipient',
    :name,
    :email,
    keyword_init: true
  )
end
