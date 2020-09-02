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
  let(:harvest) do
    body = { id: 1_234_567, first_name: 'Joe', last_name: 'Smith' }
    stub_request(:get, "#{config[:domain]}/api/v2/users/me")
      .to_return(body: body.to_json, status: 200)
    Harvest::Client.new(config)
  end

  it 'has a version number' do
    expect(Harvest::VERSION).not_to be nil
  end

  context 'with harvest' do
    it 'has active user id' do
      expect(harvest.active_user.id).to eq(1_234_567)
    end

    it 'change active state to projects' do
      expect(harvest.projects.state[:active]).to eq(:projects)
    end

    it 'change active state to time_entry' do
      expect(harvest.time_entry.state[:active]).to eq(:time_entry)
    end

    it 'find project' do
      body = { 'id' => 983_754 }
      stub_request(:get, "#{config[:domain]}/api/v2/projects/983754")
        .to_return(body: body.to_json, status: 200)
      expect(harvest.projects.find(body['id']).state[:projects][0].id).to eq(body['id'])
    end

    context 'with project assignments' do
      let(:pa_body) do
        {
          project_assignments: [
            {
              id: 349_832,
              project: { name: 'Bob Co' }
            },
            {
              id: 97_836_415,
              project: { name: 'George Co' },
              task_assignments: [
                {
                  id: 654_987,
                  task: {
                    name: 'Example Task'
                  }
                },
                {
                  id: 987_654,
                  task: {
                    name: 'Other Task'
                  }
                }
              ]
            }
          ]
        }
      end
      let(:project_assignments) do
        harvest.projects.discover.select do |pa|
          pa.project.name == 'George Co'
        end
      end
      let(:tasks) do
        project_assignments.project_tasks.discover.select do |ta|
          ta.task.name == 'Example Task'
        end
      end
      let(:te_body) do
        {
          id: 1_307_842_691,
          spent_date: Date.today.to_s,
          notes: 'Testing',
          user: {
            id: harvest.active_user.id,
            name: "#{harvest.active_user.first_name} #{harvest.active_user.last_name}"
          },
          project: {
            name: tasks.state[:filtered][:projects][0].project.name,
            id: tasks.state[:filtered][:projects][0].project.id,
            code: tasks.state[:filtered][:projects][0].project.code
          },
          task: {
            id: tasks.state[:filtered][:project_tasks][0].task.id,
            name: tasks.state[:filtered][:project_tasks][0].task.name
          },
          user_assignment: {
            id: 232_453_160
          },
          task_assignment: {
            id: tasks.state[:filtered][:project_tasks][0].id
          },
          invoice: nil,
          external_reference: nil
        }
      end

      before do
        stub_request(
          :get,
          "#{config[:domain]}/api/v2/users/#{harvest.active_user.id}/project_assignments"
        ).to_return(body: pa_body.to_json, status: 200)
      end

      # # Covered by 'create time entry from project and task'
      # xit 'select a project' do
      #   project_assignments = harvest.projects.discover.select { |pa| pa.project.name == 'Bob Co' }
      #   expect(project_assignments.state[:filtered][:projects][0].project.name).to eq('Bob Co')
      # end

      # # Covered by 'create time entry from project and task'
      # xit 'select task assignments' do
      #   project_assignments = harvest.projects.discover.select { |pa| pa.project.name == 'George Co' }
      #   tasks = project_assignments.project_tasks.discover.select { |ta| ta.task.name == 'Example Task' }
      #   expect(tasks.state[:filtered][:project_tasks][0].id).to eq(654_987)
      # end

      it 'create time entry from project and task' do
        stub_request(:post, 'https://exampledomain.harvestapp.com/api/v2/time_entries')
          .with(
            body: {
              spent_date: Date.today.to_s,
              notes: 'Testing',
              user_id: 1_234_567,
              task_id: nil,
              project_id: nil
            }.to_json
          )
          .to_return(status: 200, body: te_body.to_json, headers: {})

        time_entry = tasks.time_entry.create(**{ spent_date: Date.today.to_s, notes: 'Testing' })
        expect(time_entry.state[:time_entry].id).to eq(te_body[:id])
      end
    end
  end
end
