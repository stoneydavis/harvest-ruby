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
        # harvest.projects.discover makes an api call to
        # users/#{user.id}/project_assignments
        # In order to make this I create an Struct containing the
        # information needed for api_call from api_caller.
        # api_caller() creates a struct with default values.
        # api_call accepts the above struct and makes a request. 
        # Now I haven't been able to figure out a way to allow it to
        # execute that function without overriding it, which would make
        # this process easier as I wouldn't need to add 2 additional
        # allow's for each api call the Harvest::Client makes.
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
