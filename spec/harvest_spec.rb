RSpec.describe Harvest do
  it "has a version number" do
    expect(Harvest::VERSION).not_to be nil
  end
  config = {
    domain: 'https://exampledomain.harvestapp.com',
    account_id: 'example_account_id',
    personal_token: 'example_personal_token'
  }

  xit 'create harvest http client' do
    expect(Harvest::HTTP::Client.new(config))
  end

  # TODO: create double of Harvest::HTTP::Client
  let(:client) { Harvest::HTTP::Client.new(config) }

  xit 'create harvest client' do
    expect(Harvest::Client.new(client))
  end

  let(:harvest) { Harvest::Client.new(client) }
  context 'harvest client' do
    xit 'sets active_user' do
      expect(harvest.active_user.id).to be(123_456_789_012)
    end
    xit 'sets client' do
      expect(harvest.client).to be_instance_of(Harvest::HTTP::Client)
    end
    xit 'sets state' do
      expect(harvest.state).to eq('')
    end
    xit 'sets project state' do
      expect(harvest.projects.state).to eq('projects')
    end
  end
end
