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
            hours: 8.0,
            rounded_hours: 8.0,
            notes: 'pto',
            is_locked: false,
            locked_reason: nil,
            is_closed: false,
            is_billed: false,
            timer_started_at: nil,
            started_time: nil,
            ended_time: nil,
            is_running: false,
            billable: false,
            budgeted: false,
            billable_rate: nil,
            cost_rate: nil,
            created_at: '2020-08-26T14:59:57Z',
            updated_at: '2020-08-26T14:59:57Z',
            user: {
              id: 2_374_567,
              name: 'Craig Davis'
            },
            client: {
              id: 5_743_008,
              name: 'Onica',
              currency: 'USD'

            },
            project: {
              id: 23_938_119,
              name: 'Onica - EE Internal',
              code: '16282'

            },
            task: {
              id: 8_089_355,
              name: 'PTO'

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
            rounded_hours: 0.2,
            notes: 'on call review',
            is_locked: false,
            locked_reason: nil,
            is_closed: false,
            is_billed: false,
            timer_started_at: '2020-09-02T16:59:40Z',
            started_time: '11:59am',
            ended_time: nil,
            is_running: true,
            billable: false,
            budgeted: false,
            billable_rate: nil,
            cost_rate: nil,
            created_at: '2020-09-02T16:59:40Z',
            updated_at: '2020-09-02T16:59:40Z',
            user: {
              id: 2_374_567,
              name: 'Craig Davis'
            },
            client: {
              id: 5_743_008,
              name: 'Onica',
              currency: 'USD'
            },
            project: {
              id: 23_938_119,
              name: 'Onica - EE Internal',
              code: '16282'
            },
            task: {
              id: 13_836_057,
              name: 'Scrum/Team Meetings'
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

            }, {
              id: 97_836_415,
              project: { name: 'George Co' }, task_assignments: [
                {
                  id: 654_987,
                  task: {
                    name: 'Example Task'
                  }

                }, {
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

          },          project: {
            name: tasks.state[:filtered][:projects][0].project.name,
            id: tasks.state[:filtered][:projects][0].project.id,
            code: tasks.state[:filtered][:projects][0].project.code

          },          task: {
            id: tasks.state[:filtered][:project_tasks][0].task.id,
            name: tasks.state[:filtered][:project_tasks][0].task.name

          },          user_assignment: {
            id: 232_453_160

          },          task_assignment: {
            id: tasks.state[:filtered][:project_tasks][0].id

          },          invoice: nil,
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

    it 'discover time_entries' do
      stub_request(:get, "#{config[:domain]}/api/v2/time_entries")
        .to_return(status: 200, body: tes_body.to_json, headers: {})

      harvest.time_entry.discover(from: Date.today.yesterday.to_s)
    end
  end
end
