# frozen_string_literal: true

require 'pry'
require 'active_support/core_ext/date/calculations'

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

  it 'change state to invalid state raises NoMethodError' do
    expect { harvest.no_such_method }.to raise_error(Harvest::Exceptions::BadState)
  end

  context 'with harvest' do
    let(:tes_body) do
      {
        per_page: 100,
        total_pages: 1,
        total_entries: 2,
        previous_page: nil,
        page: 1,
        time_entries: [
          {
            id: 1_302_371_653,
            spent_date: '2020-09-14',
            notes: 'Example Note',
            user: {
              id: 2_374_567,
              name: 'Joe Smith'
            },
            client: {
              id: 5_743_008,
              name: 'Smith Co.',
              currency: 'USD'

            },
            project: {
              id: 23_938_119,
              name: 'Internal',
              code: '14562'

            },
            task: {
              id: 8_089_355,
              name: 'Billing Code'

            },
            user_assignment: {
              id: 231_628_123,
              is_project_manager: false,
              is_active: true,
              use_default_rates: true,
              budget: nil,
              created_at: '2020-02-07T19:27:12Z',
              updated_at: '2020-02-07T19:27:12Z',
              hourly_rate: nil

            },
            task_assignment: {
              id: 257_614_925,
              billable: false,
              is_active: true,
              created_at: '2020-02-07T19:17:12Z',
              updated_at: '2020-02-07T19:17:12Z',
              hourly_rate: nil,
              budget: nil

            },
            invoice: nil,
            external_reference: nil

          },
          {
            id: 1_308_094_896,
            spent_date: '2020-09-02',
            hours: 0.2,
            notes: 'Other Example',
            timer_started_at: '2020-09-02T16:59:40Z',
            started_time: '11:59am',
            created_at: '2020-09-02T16:59:40Z',
            updated_at: '2020-09-02T16:59:40Z',
            user: {
              id: 2_374_567,
              name: 'Joe Smith'
            },
            client: {
              id: 5_743_108,
              name: 'Other Client',
              currency: 'USD'
            },
            project: {
              id: 23_938_119,
              name: 'Other Project',
              code: '4'
            },
            task: {
              id: 13_836_057,
              name: 'Other Task'
            },
            user_assignment: {
              id: 231_628_123,
              is_project_manager: false,
              is_active: true,
              use_default_rates: true,
              budget: nil,
              created_at: '2020-02-07T19:27:12Z',
              updated_at: '2020-02-07T19:27:12Z',
              hourly_rate: nil
            },
            task_assignment: {
              id: 257_614_929,
              billable: false,
              is_active: true,
              created_at: '2020-02-07T19:17:12Z',
              updated_at: '2020-02-07T19:17:12Z',
              hourly_rate: nil,
              budget: nil
            },
            invoice: nil,
            external_reference: nil
          }
        ]
      }
    end

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
      body = { id: 983_754 }
      stub_request(:get, "#{config[:domain]}/api/v2/projects/#{body[:id]}")
        .to_return(body: body.to_json, status: 200)
      expect(harvest.projects.find(body[:id]).state[:projects][0].id).to eq(body[:id])
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
            name: tasks.state[:projects][0].project.name,
            id: tasks.state[:projects][0].project.id,
            code: tasks.state[:projects][0].project.code

          },
          task: {
            id: tasks.state[:project_tasks][0].task.id,
            name: tasks.state[:project_tasks][0].task.name

          },
          user_assignment: {
            id: 232_453_160

          },
          task_assignment: {
            id: tasks.state[:project_tasks][0].id

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
        stub_request(:post, "#{config[:domain]}/api/v2/time_entries")
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
      end

      # Covered by 'create time entry from project and task'
      it 'select a project' do
        project_assignments = harvest.projects.discover.select { |pa| pa.project.name == 'Bob Co' }
        expect(project_assignments.data.length).to eq(1)
        expect(project_assignments.data[0].project.name).to eq('Bob Co')
      end

      # Covered by 'create time entry from project and task'
      it 'select task assignments' do
        tasks = harvest
                .projects
                .discover
                .select { |pa| pa.project.name == 'George Co' }
                .project_tasks
                .discover
                .select { |ta| ta.task.name == 'Example Task' }
        expect(tasks.data[0].id).to eq(654_987)
      end

      it 'create time entry from project and task' do
        time_entry = tasks.time_entry.create(**{ spent_date: Date.today.to_s, notes: 'Testing' })
        expect(time_entry.state[:time_entry].id).to eq(te_body[:id])
      end

      it 'map a selected projects' do
        project_assignments = harvest
                              .projects.discover
                              .select { |pa| pa.project.name == 'Bob Co' }
                              .map { |pa| pa.project.name }
        expect(project_assignments).to eq(['Bob Co'])
      end

      it 'map projects' do
        project_assignments = harvest
                              .projects.discover
                              .map { |pa| pa.project.name }
        expect(project_assignments).to eq(['Bob Co', 'George Co'])
      end
    end

    context 'with time entry' do
      before do
        stub_request(:get, "#{config[:domain]}/api/v2/time_entries")
          .to_return(status: 200, body: tes_body.to_json)
        specific_te = { id: 1_306_062_565 }
        stub_request(:get, 'https://exampledomain.harvestapp.com/api/v2/time_entry/1306062565')
          .to_return(status: 200, body: specific_te.to_json, headers: {})
      end

      it 'discover time_entries' do
        time_entries = harvest.time_entry.discover(from: Date.today.yesterday.to_s)
        expect(time_entries.state[:time_entry][0].notes).to eq('Example Note')
      end

      it 'find a time entry' do
        expect(harvest.time_entry.find(1_306_062_565).state[:time_entry][0].id).to(
          eq(1_306_062_565)
        )
      end
    end
  end
end
