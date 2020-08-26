# frozen_string_literal: true

RSpec.describe Harvest::ResourceFactory do
  factory = Harvest::ResourceFactory.new
  project_assignment_raw = {
    id: 123_456_789,
    is_project_manager: false,
    is_active: true,
    use_default_rates: true,
    budget: nil,
    created_at: '2020-08-14T22:32:40Z',
    updated_at: '2020-08-14T22:32:40Z',
    hourly_rate: nil,
    project: {
      id: 12_345_678,
      name: 'Customer Name',
      code: '16393'
    },
    client: {
      id: 1_234_567,
      name: 'Customer Name',
      currency: 'USD'
    },
    task_assignments: [
      {
        id: 987_654_321,
        billable: false,
        is_active: true,
        created_at: '2020-08-14T22:32:40Z',
        updated_at: '2020-08-14T22:32:40Z',
        hourly_rate: nil,
        budget: nil,
        task: {
          id: 11_299_508,
          name: 'Non-Billable - MGMT'
        }
      },
      {
        id: 456_789_123,
        billable: true,
        is_active: true,
        created_at: '2020-08-14T22:32:40Z',
        updated_at: '2020-08-14T22:32:57Z',
        hourly_rate: nil,
        budget: 50.0,
        task: {
          id: 11_585_229,
          name: 'Teams'
        }
      }
    ]
  }
  # tests ProjectAssignment, Client, Project, TaskAssignment, Tasks, converting dates
  it 'create project assignment struct with nested Client, Project, TaskAssignment, Tasks and formatted dates' do
    pa = factory.project_assignment(project_assignment_raw)
    expect(pa).to have_attributes({ is_active: true, id: 123456789 })
    expect(pa.project).to have_attributes({ name: 'Customer Name', code: '16393' })
    expect(pa.client).to have_attributes({ name: 'Customer Name', currency: 'USD' })
    expect(pa.created_at).to be_instance_of(DateTime)
    expect(pa.updated_at).to be_instance_of(DateTime)
    expect(pa.task_assignments.length).to eq(2)
    expect(pa.task_assignments[0]).to have_attributes({ is_active: true, id: 987_654_321 })
    expect(pa.task_assignments[0].task).to have_attributes({ id: 11_299_508 })
  end

  time_entry_raw = {
    id: 1301576365,
    spent_date: '2020-08-25',
    user: {
      id: 2374567,
      name: 'John Smith'
    },
    user_assignment: {
      id: 173839681,
      is_project_manager: false,
      is_active: true,
      use_default_rates: false,
      budget: nil,
      created_at: '2018-10-08T16:16:40Z',
      updated_at: '2018-10-08T16:16:40Z',
      hourly_rate: nil
    },
    client: {
      id: 6424708,
      name: 'Client Name',
      currency: 'USD'
    },
    project: {
      id: 16217966,
      name: 'Project Name',
      code: '16117'
    },
    task: {
      id: 8100053,
      name: 'Ops'
    },
    task_assignment: {
      id: 175684707,
      billable: true,
      is_active: true,
      created_at: '2018-01-22T20:03:30Z',
      updated_at: '2019-01-11T20:45:31Z',
      hourly_rate: nil,
      budget: nil
    },
    external_reference: {
      id: '120458',
      group_id: '16117',
      permalink: 'https://example.com',
      service: 'example.com',
      service_icon_url: 'https://example.com/name.png'
    },
    invoice: nil,
    hours: 0.43,
    rounded_hours: 0.43,
    notes: 'Notes found here',
    is_locked: false,
    locked_reason: nil,
    is_closed: false,
    is_billed: false,
    timer_started_at: '2020-08-25T17:30:37Z',
    started_time: nil,
    ended_time: nil,
    is_running: true,
    billable: true,
    budgeted: false,
    billable_rate: nil,
    cost_rate: nil,
    created_at: '2020-08-14T22:32:40Z',
    updated_at: '2020-08-14T22:32:57Z'
  }
  it 'Create TimeEntry with the following nested object: Project, Client, TaskAssignment, Task, ExternalReference, UserAssignment, User' do
    te = factory.time_entry(time_entry_raw)
    expect(te.project).to have_attributes({ name: 'Project Name' })
    expect(te.client).to have_attributes({ name: 'Client Name' })
    expect(te.task).to have_attributes({ name: 'Ops' })
    expect(te.task_assignment).to have_attributes({ id: 175684707 })
    expect(te.external_reference).to have_attributes({ service: 'example.com' })
  end

  it 'Create blank TimeEntry' do
    te = factory.time_entry(nil)
    expect(te.id).to be_nil
    expect(te.user.id).to be_nil
    expect(te.user_assignment.id).to be_nil
    expect(te.client.id).to be_nil
    expect(te.project.id).to be_nil
    expect(te.task.id).to be_nil
    expect(te.task_assignment.id).to be_nil
    expect(te.external_reference.service).to be_nil
  end

  it 'Create blank ProjectAssignment' do
    te = factory.project_assignment(nil)
  end
end
