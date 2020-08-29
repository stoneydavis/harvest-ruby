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
    expect(Harvest::HTTP::Client.new(config))
  end


  describe Harvest::Client do
    context 'when called' do
      before (:each) do
        @client = Harvest::HTTP::Client.new(config)
        @me_user = Harvest::HTTP::ApiCall.new(path: '/users/me', http_method: 'get', headers: {}, param: {})
        @projects = Harvest::HTTP::ApiCall.new(path: 'projects/1123456', http_method: 'get', headers: {}, param: {})
        allow(@client)
          .to receive(:api_call)
          .with(@me_user)
          .and_return({id: 789456, first_name: 'Bob', last_name: 'Smith' })
        allow(@client)
          .to receive(:api_caller)
          .with('/users/me')
          .and_return(@me_user)
        allow(@client)
          .to receive(:api_caller)
          .with('projects/1123456')
          .and_return(@projects)
        allow(@client)
          .to receive(:api_call)
          .with(@projects)
          .and_return({id: 1123456})
        # I need to add 2 additional items for every api call, one to
        # generate the struct from api_caller that is then recieved by api_call.
        # I now need to do a user project assignment one now and it will only 
        # grow from here
      end

      it 'creates Client, sets active user' do
        harvest = Harvest::Client.new(@client)
        expect(harvest.active_user.id).to be(789456)
      end
      xit 'discover projects' do
        harvest = Harvest::Client.new(@client)
        expect(harvest.projects.discover).to eq('')
      end
      xit 'find one project' do
        harvest = Harvest::Client.new(@client)
        expect(harvest.projects.find(id: 1123456)).to eq('')
      end
    end
  end
end
