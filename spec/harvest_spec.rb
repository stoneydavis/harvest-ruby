# frozen_string_literal: true

require 'pry'

RSpec.describe Harvest do
  let(:config) do
    {
      domain: 'https://exampledomain.harvestapp.com',
      account_id: 'example_account_id',
      personal_token: 'example_personal_token'
    }
  end
  let(:harvest) { Harvest::Client.new(config) }

  it 'has a version number' do
    expect(Harvest::VERSION).not_to be nil
  end

  it 'creates harvest client' do
    body = { 'id' => 1_234_567 }
    stub_request(:get, "#{config[:domain]}/api/v2/users/me")
      .to_return(body: body.to_json, status: 200)
    expect(Harvest::Client.new(config).active_user.id).to eq(body['id'])
  end

  context 'harvest' do
    before do
      body = { 'id' => 1_234_567 }
      stub_request(:get, "#{config[:domain]}/api/v2/users/me")
        .to_return(body: body.to_json, status: 200)
      @harvest = Harvest::Client.new(config)
    end

    it 'change active state to projects' do
      expect(@harvest.projects.state[:active]).to eq(:projects)
    end

    it 'change active state to time_entry' do
      expect(@harvest.time_entry.state[:active]).to eq(:time_entry)
    end

    it 'find project' do
      body = { 'id' => 983_754 }
      stub_request(:get, "#{config[:domain]}/api/v2/projects/983754")
        .to_return(body: body.to_json, status: 200)
      expect(@harvest.projects.find(body['id']).state[:projects][0].id).to eq(body['id'])
    end
  end
end
