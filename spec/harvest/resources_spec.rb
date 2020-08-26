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
end
