# frozen_string_literal: true

module Harvest
  # @param id [integer]
  #   Unique ID for the estimate.
  # @param client [object]
  #   An object containing estimate’s client id and name.
  # @param line_items [array]
  #   Array of estimate line items.
  # @param creator [object]
  #   An object containing the id and name of the person that created the estimate.
  # @param client_key [string]
  #   Used to build a URL to the public web invoice for your client:
  # @param number [string]
  #   If no value is set, the number will be automatically generated.
  # @param purchase_order [string]
  #   The purchase order number.
  # @param amount [decimal]
  #   The total amount for the estimate, including any discounts and taxes.
  # @param tax [decimal]
  #   This percentage is applied to the subtotal, including line items and discounts.
  # @param tax_amount [decimal]
  #   The first amount of tax included, calculated from tax. If no tax is defined, this value will be null.
  # @param tax2 [decimal]
  #   This percentage is applied to the subtotal, including line items and discounts.
  # @param tax2_amount [decimal]
  #   The amount calculated from tax2.
  # @param discount [decimal]
  #   This percentage is subtracted from the subtotal.
  # @param discount_amount [decimal]
  #   The amount calcuated from discount.
  # @param subject [string]
  #   The estimate subject.
  # @param notes [string]
  #   Any additional notes included on the estimate.
  # @param currency [string]
  #   The currency code associated with this estimate.
  # @param state [string]
  #   The current state of the estimate: draft, sent, accepted, or declined.
  # @param issue_date [date]
  #   Date the estimate was issued.
  # @param sent_at [datetime]
  #   Date and time the estimate was sent.
  # @param accepted_at [datetime]
  #   Date and time the estimate was accepted.
  # @param declined_at [datetime]
  #   Date and time the estimate was declined.
  # @param created_at [datetime]
  #   Date and time the estimate was created.
  # @param updated_at [datetime]
  #   Date and time the estimate was last updated.
  Estimate = Struct.new(
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

  # @param id [integer]
  #   Unique ID for the line item.
  # @param kind [string]
  #   The name of an estimate item category.
  # @param description [string]
  #   Text description of the line item.
  # @param quantity [integer]
  #   The unit quantity of the item.
  # @param unit_price [decimal]
  #   The individual price per unit.
  # @param amount [decimal]
  #   The line item subtotal (quantity * unit_price).
  # @param taxed [boolean]
  #   Whether the estimate’s tax percentage applies to this line item.
  # @param taxed2 [boolean]
  #   Whether the estimate’s tax2 percentage applies to this line item.
  EstimateLineItem = Struct.new(
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

  # @param id [integer]
  #   Unique ID for the message.
  # @param sent_by [string]
  #   Name of the user that created the message.
  # @param sent_by_email [string]
  #   Email of the user that created the message.
  # @param sent_from [string]
  #   Name of the user that the message was sent from.
  # @param sent_from_email [string]
  #   Email of the user that message was sent from.
  # @param recipients [array]
  #   Array of estimate message recipients.
  # @param subject [string]
  #   The message subject.
  # @param body [string]
  #   The message body.
  # @param send_me_a_copy [boolean]
  #   Whether to email a copy of the message to the current user.
  # @param event_type [string]
  #   The type of estimate event that occurred with the message: send, accept, decline, re-open, view, or invoice.
  # @param created_at [datetime]
  #   Date and time the message was created.
  # @param updated_at [datetime]
  #   Date and time the message was last updated.
  EstimateMessage = Struct.new(
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

  # @param id [integer]
  #   Unique ID for the estimate item category.
  # @param name [string]
  #   The name of the estimate item category.
  # @param created_at [datetime]
  #   Date and time the estimate item category was created.
  # @param updated_at [datetime]
  #   Date and time the estimate item category was last updated.
  EstimateItemCategory = Struct.new(
    :id,
    :name,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
