# frozen_string_literal: true

module Harvest
  # @param base_uri [string]
  #   The Harvest URL for the company.
  # @param full_domain [string]
  #   The Harvest domain for the company.
  # @param name [string]
  #   The name of the company.
  # @param is_active [boolean]
  #   Whether the company is active or archived.
  # @param week_start_day [string]
  #   The week day used as the start of the week. Returns one of: Saturday, Sunday, or Monday.
  # @param wants_timestamp_timers [boolean]
  #   Whether time is tracked via duration or start and end times.
  # @param time_format [string]
  #   The format used to display time in Harvest. Returns either decimal or hours_minutes.
  # @param plan_type [string]
  #   The type of plan the company is on. Examples: trial, free, or simple-v4
  # @param clock [string]
  #   Used to represent whether the company is using a 12-hour or 24-hour clock. Returns either 12h or 24h.
  # @param decimal_symbol [string]
  #   Symbol used when formatting decimals.
  # @param thousands_separator [string]
  #   Separator used when formatting numbers.
  # @param color_scheme [string]
  #   The color scheme being used in the Harvest web client.
  # @param weekly_capacity [integer]
  #   The weekly capacity in seconds.
  # @param expense_feature [boolean]
  #   Whether the expense module is enabled.
  # @param invoice_feature [boolean]
  #   Whether the invoice module is enabled.
  # @param estimate_feature [boolean]
  #   Whether the estimate module is enabled.
  # @param approval_feature [boolean]
  #   Whether the approval module is enabled.
  Company = Struct.new(
    :base_uri,
    :full_domain,
    :name,
    :is_active,
    :week_start_day,
    :wants_timestamp_timers,
    :time_format,
    :plan_type,
    :clock,
    :decimal_symbol,
    :thousands_separator,
    :color_scheme,
    :weekly_capacity,
    :expense_feature,
    :invoice_feature,
    :estimate_feature,
    :approval_feature,
    keyword_init: true
  )
end
