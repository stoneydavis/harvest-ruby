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
    body = {
      'id' => 1_234_567,
      'first_name' => 'John',
      'last_name' => 'Smith',
      'email' => 'user@example.com',
      'telephone' => '',
      'timezone' => 'Central Time (US & Canada)',
      'weekly_capacity' => 144_000,
      'has_access_to_all_future_projects' => false,
      'is_contractor' => false,
      'is_admin' => false,
      'is_project_manager' => false,
      'can_see_rates' => false,
      'can_create_projects' => false,
      'can_create_invoices' => false,
      'is_active' => true,
      'calendar_integration_enabled' => true,
      'calendar_integration_source' => 'outlook',
      'created_at' => '2018-10-08T16:13:37Z',
      'updated_at' => '2020-08-14T22:32:40Z',
      'roles' => [],
      'avatar_url' =>
      'https://d3s3969qhosaug.cloudfront.net/default-avatars/1.png'
    }

    stub_request(:get, "#{config[:domain]}/api/v2/users/me")
      .to_return(body: body.to_json, status: 200)
    expect(Harvest::Client.new(config).active_user.id).to eq(body['id'])
  end
  context 'harvest' do
  end
end
