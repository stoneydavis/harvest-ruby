# frozen_string_literal: true

module Harvest
  # @param id [Integer]
  #   Unique ID for the estimate.
  # @param client [Struct]
  #   An object containing estimate's client id and name.
  # @param line_items [List]
  #   Array of estimate line items.
  # @param creator [Struct]
  #   An object containing the id and name of the person that created the estimate.
  # @param client_key [String]
  #   Used to build a URL to the public web invoice for your client:
  # @param number [String]
  #   If no value is set, the number will be automatically generated.
  # @param purchase_order [String]
  #   The purchase order number.
  # @param amount [decimal]
  #   The total amount for the estimate, including any discounts and taxes.
  # @param tax [decimal]
  #   This percentage is applied to the subtotal, including line items and
  #   discounts.
  # @param tax_amount [decimal]
  #   The first amount of tax included, calculated from tax. If no tax is
  #   defined, this value will be null.
  # @param tax2 [decimal]
  #   This percentage is applied to the subtotal, including line items and
  #   discounts.
  # @param tax2_amount [decimal]
  #   The amount calculated from tax2.
  # @param discount [decimal]
  #   This percentage is subtracted from the subtotal.
  # @param discount_amount [decimal]
  #   The amount calcuated from discount.
  # @param subject [String]
  #   The estimate subject.
  # @param notes [String]
  #   Any additional notes included on the estimate.
  # @param currency [String]
  #   The currency code associated with this estimate.
  # @param state [String]
  #   The current state of the estimate: draft, sent, accepted, or declined.
  # @param issue_date [Date]
  #   Date the estimate was issued.
  # @param sent_at [DateTime]
  #   Date and time the estimate was sent.
  # @param accepted_at [DateTime]
  #   Date and time the estimate was accepted.
  # @param declined_at [DateTime]
  #   Date and time the estimate was declined.
  # @param created_at [DateTime]
  #   Date and time the estimate was created.
  # @param updated_at [DateTime]
  #   Date and time the estimate was last updated.
  Struct.new(
    'Estimate',
    :id,
    :client,
    :line_items,
    :creator,
    :client_key,
    :number,
    :purchase_order,
    :amount,
    :tax,
    :tax_amount,
    :tax2,
    :tax2_amount,
    :discount,
    :discount_amount,
    :subject,
    :notes,
    :currency,
    :state,
    :issue_date,
    :sent_at,
    :accepted_at,
    :declined_at,
    :created_at,
    :updated_at,
    keyword_init: true
  )

  # @param id [Integer]
  #   Unique ID for the line item.
  # @param kind [String]
  #   The name of an estimate item category.
  # @param description [String]
  #   Text description of the line item.
  # @param quantity [Integer]
  #   The unit quantity of the item.
  # @param unit_price [decimal]
  #   The individual price per unit.
  # @param amount [decimal]
  #   The line item subtotal (quantity * unit_price).
  # @param taxed [Boolean]
  #   Whether the estimate's tax percentage applies to this line item.
  # @param taxed2 [Boolean]
  #   Whether the estimate's tax2 percentage applies to this line item.
  Struct.new(
    'EstimateLineItem',
    :id,
    :kind,
    :description,
    :quantity,
    :unit_price,
    :amount,
    :taxed,
    :taxed2,
    keyword_init: true
  )

  # @param id [Integer]
  #   Unique ID for the message.
  # @param sent_by [String]
  #   Name of the user that created the message.
  # @param sent_by_email [String]
  #   Email of the user that created the message.
  # @param sent_from [String]
  #   Name of the user that the message was sent from.
  # @param sent_from_email [String]
  #   Email of the user that message was sent from.
  # @param recipients [List]
  #   Array of estimate message recipients.
  # @param subject [String]
  #   The message subject.
  # @param body [String]
  #   The message body.
  # @param send_me_a_copy [Boolean]
  #   Whether to email a copy of the message to the current user.
  # @param event_type [String]
  #   The type of estimate event that occurred with the message: send, accept,
  #   decline, re-open, view, or invoice.
  # @param created_at [DateTime]
  #   Date and time the message was created.
  # @param updated_at [DateTime]
  #   Date and time the message was last updated.
  Struct.new(
    'EstimateMessage',
    :id,
    :sent_by,
    :sent_by_email,
    :sent_from,
    :sent_from_email,
    :recipients,
    :subject,
    :body,
    :send_me_a_copy,
    :event_type,
    :created_at,
    :updated_at,
    keyword_init: true
  )

  # @param id [Integer]
  #   Unique ID for the estimate item category.
  # @param name [String]
  #   The name of the estimate item category.
  # @param created_at [DateTime]
  #   Date and time the estimate item category was created.
  # @param updated_at [DateTime]
  #   Date and time the estimate item category was last updated.
  Struct.new(
    'EstimateItemCategory',
    :id,
    :name,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
