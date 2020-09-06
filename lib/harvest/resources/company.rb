# frozen_string_literal: true

module Harvest
  module Resources
    # @param base_uri [String]
    #   The Harvest URL for the company.
    # @param full_domain [String]
    #   The Harvest domain for the company.
    # @param name [String]
    #   The name of the company.
    # @param is_active [Boolean]
    #   Whether the company is active or archived.
    # @param week_start_day [String]
    #   The week day used as the start of the week. Returns one of: Saturday, Sunday, or Monday.
    # @param wants_timestamp_timers [Boolean]
    #   Whether time is tracked via duration or start and end times.
    # @param time_format [String]
    #   The format used to display time in Harvest. Returns either decimal or hours_minutes.
    # @param plan_type [String]
    #   The type of plan the company is on. Examples: trial, free, or simple-v4
    # @param clock [String]
    #   Used to represent whether the company is using a 12-hour or 24-hour clock.
    #   Returns either 12h or 24h.
    # @param decimal_symbol [String]
    #   Symbol used when formatting decimals.
    # @param thousands_separator [String]
    #   Separator used when formatting numbers.
    # @param color_scheme [String]
    #   The color scheme being used in the Harvest web client.
    # @param weekly_capacity [Integer]
    #   The weekly capacity in seconds.
    # @param expense_feature [Boolean]
    #   Whether the expense module is enabled.
    # @param invoice_feature [Boolean]
    #   Whether the invoice module is enabled.
    # @param estimate_feature [Boolean]
    #   Whether the estimate module is enabled.
    # @param approval_feature [Boolean]
    #   Whether the approval module is enabled.
    Company = Struct.new(
      'Company',
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
end
