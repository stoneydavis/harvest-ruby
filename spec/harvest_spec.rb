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

  xit 'create harvest http client' do
    expect(Harvest::HTTP::Client.new(config))
  end

  let(:client) { instance_double(Harvest::HTTP::Client, api_caller: Harvest::HTTP::ApiCall.new, paginator: Harvest::HTTP::Pagination.new, api_call: {id: 123_456_789_012}, pagination: {}) }

  let(:harvest) { Harvest::Client.new(client) }
  context 'harvest client' do
    it 'create harvest client' do
      expect(Harvest::Client.new(client))
    end

    it 'sets active_user' do
      expect(harvest.active_user.id).to be(123_456_789_012)
    end

    # Once the discover test is implemented I should be able to remove this entirely
    it 'sets project state' do
      expect(harvest.projects.instance_variable_get("@state")[:default]).to eq(:projects)
    end

    xit 'discovers projects' do
      expect(harvest.projects.discover).to eq('')
    end
  end
end
