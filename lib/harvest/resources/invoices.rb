# frozen_string_literal: true

module Harvest
  # @param id [integer]
  #   Unique ID for the invoice.
  # @param client [object]
  #   An object containing invoice's client id and name.
  # @param line_items [array]
  #   Array of invoice line items.
  # @param estimate [object]
  #   An object containing the associated estimate's id.
  # @param retainer [object]
  #   An object containing the associated retainer's id.
  # @param creator [object]
  #   An object containing the id and name of the person that created the invoice.
  # @param client_key [string]
  #   Used to build a URL to the public web invoice for your client:
  # @param number [string]
  #   If no value is set, the number will be automatically generated.
  # @param purchase_order [string]
  #   The purchase order number.
  # @param amount [decimal]
  #   The total amount for the invoice, including any discounts and taxes.
  # @param due_amount [decimal]
  #   The total amount due at this time for this invoice.
  # @param tax [decimal]
  #   This percentage is applied to the subtotal, including line items and discounts.
  # @param tax_amount [decimal]
  #   The first amount of tax included, calculated from tax. If no tax is
  #   defined, this value will be null.
  # @param tax2 [decimal]
  #   This percentage is applied to the subtotal, including line items and discounts.
  # @param tax2_amount [decimal]
  #   The amount calculated from tax2.
  # @param discount [decimal]
  #   This percentage is subtracted from the subtotal.
  # @param discount_amount [decimal]
  #   The amount calcuated from discount.
  # @param subject [string]
  #   The invoice subject.
  # @param notes [string]
  #   Any additional notes included on the invoice.
  # @param currency [string]
  #   The currency code associated with this invoice.
  # @param state [string]
  #   The current state of the invoice: draft, open, paid, or closed.
  # @param period_start [date]
  #   Start of the period during which time entries were added to this invoice.
  # @param period_end [date]
  #   End of the period during which time entries were added to this invoice.
  # @param issue_date [date]
  #   Date the invoice was issued.
  # @param due_date [date]
  #   Date the invoice is due.
  # @param payment_term [string]
  #   The timeframe in which the invoice should be paid. Options: upon receipt,
  #   net 15, net 30, net 45, net 60, or custom.
  # @param sent_at [datetime]
  #   Date and time the invoice was sent.
  # @param paid_at [datetime]
  #   Date and time the invoice was paid.
  # @param paid_date [date]
  #   Date the invoice was paid.
  # @param closed_at [datetime]
  #   Date and time the invoice was closed.
  # @param recurring_invoice_id [integer]
  #   Unique ID of the associated recurring invoice.
  # @param created_at [datetime]
  #   Date and time the invoice was created.
  # @param updated_at [datetime]
  #   Date and time the invoice was last updated.
  Struct.new(
    'Invoice',
    :id,
    :client,
    :line_items,
    :estimate,
    :retainer,
    :creator,
    :client_key,
    :number,
    :purchase_order,
    :amount,
    :due_amount,
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
    :period_start,
    :period_end,
    :issue_date,
    :due_date,
    :payment_term,
    :sent_at,
    :paid_at,
    :paid_date,
    :closed_at,
    :recurring_invoice_id,
    :created_at,
    :updated_at,
    keyword_init: true
  )

  # @param id [integer]
  #   Unique ID for the line item.
  # @param project [object]
  #   An object containing the associated project's id, name, and code.
  # @param kind [string]
  #   The name of an invoice item category.
  # @param description [string]
  #   Text description of the line item.
  # @param quantity [decimal]
  #   The unit quantity of the item.
  # @param unit_price [decimal]
  #   The individual price per unit.
  # @param amount [decimal]
  #   The line item subtotal (quantity * unit_price).
  # @param taxed [boolean]
  #   Whether the invoice's tax percentage applies to this line item.
  # @param taxed2 [boolean]
  #   Whether the invoice's tax2 percentage applies to this line item.
  Struct.new(
    'InvoiceLineItem',
    :id,
    :project,
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
  #   Array of invoice message recipients.
  # @param subject [string]
  #   The message subject.
  # @param body [string]
  #   The message body.
  # @param include_link_to_client_invoice [boolean]
  #   Whether to include a link to the client invoice in the message body. Not
  #   used when thank_you is true.
  # @param attach_pdf [boolean]
  #   Whether to attach the invoice PDF to the message email.
  # @param send_me_a_copy [boolean]
  #   Whether to email a copy of the message to the current user.
  # @param thank_you [boolean]
  #   Whether this is a thank you message.
  # @param event_type [string]
  #   The type of invoice event that occurred with the message: send, close,
  #   draft, re-open, or view.
  # @param reminder [boolean]
  #   Whether this is a reminder message.
  # @param send_reminder_on [date]
  #   The date the reminder email will be sent.
  # @param created_at [datetime]
  #   Date and time the message was created.
  # @param updated_at [datetime]
  #   Date and time the message was last updated.
  Struct.new(
    'InvoiceMessage',
    :id,
    :sent_by,
    :sent_by_email,
    :sent_from,
    :sent_from_email,
    :recipients,
    :subject,
    :body,
    :include_link_to_client_invoice,
    :attach_pdf,
    :send_me_a_copy,
    :thank_you,
    :event_type,
    :reminder,
    :send_reminder_on,
    :created_at,
    :updated_at,
    keyword_init: true
  )

  # @param id [integer]
  #   Unique ID for the payment.
  # @param amount [decimal]
  #   The amount of the payment.
  # @param paid_at [datetime]
  #   Date and time the payment was made.
  # @param paid_date [date]
  #   Date the payment was made.
  # @param recorded_by [string]
  #   The name of the person who recorded the payment.
  # @param recorded_by_email [string]
  #   The email of the person who recorded the payment.
  # @param notes [string]
  #   Any notes associated with the payment.
  # @param transaction_id [string]
  #   Either the card authorization or PayPal transaction ID.
  # @param payment_gateway [object]
  #   The payment gateway id and name used to process the payment.
  # @param created_at [datetime]
  #   Date and time the payment was recorded.
  # @param updated_at [datetime]
  #   Date and time the payment was last updated.
  Struct.new(
    'InvoicePayment',
    :id,
    :amount,
    :paid_at,
    :paid_date,
    :recorded_by,
    :recorded_by_email,
    :notes,
    :transaction_id,
    :payment_gateway,
    :created_at,
    :updated_at,
    keyword_init: true
  )

  # @param id [integer]
  #   Unique ID for the invoice item category.
  # @param name [string]
  #   The name of the invoice item category.
  # @param use_as_service [boolean]
  #   Whether this invoice item category is used for billable hours when generating an invoice.
  # @param use_as_expense [boolean]
  #   Whether this invoice item category is used for expenses when generating an invoice.
  # @param created_at [datetime]
  #   Date and time the invoice item category was created.
  # @param updated_at [datetime]
  #   Date and time the invoice item category was last updated.
  Struct.new(
    'InvoiceItemCategory',
    :id,
    :name,
    :use_as_service,
    :use_as_expense,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
