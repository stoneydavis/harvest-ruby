# frozen_string_literal: true

require 'pry'

RSpec.describe Harvest do
  it 'has a version number' do
    expect(Harvest::VERSION).not_to be nil
  end
  let(:config) do
    {
      domain: 'https://exampledomain.harvestapp.com',
      account_id: 'example_account_id',
      personal_token: 'example_personal_token'
    }
  end

  it 'create harvest http client' do
    expect(Harvest::HTTP::Api.new(config))
  end
end
