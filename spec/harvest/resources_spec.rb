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

  let(:pa) { factory.project_assignment(project_assignment_raw) }

  context 'when creating project assignment struct' do
    it 'sets project assignment id' do
      expect(pa.id).to eq(123_456_789)
    end
    it 'sets is_active' do
      expect(pa.is_active).to eq(true)
    end
    it 'sets project name' do
      expect(pa.project.name).to eq('Customer Name')
    end
    it 'sets project code' do
      expect(pa.project.code).to eq('16393')
    end
    it 'sets created_at' do
      expect(pa.created_at).to be_instance_of(DateTime)
    end
    it 'sets updated_at' do
      expect(pa.updated_at).to be_instance_of(DateTime)
    end
    it 'sets client name' do
      expect(pa.client.name).to eq('Customer Name')
    end
    it 'sets client currency' do
      expect(pa.client.currency).to eq('USD')
    end
    it 'has task assignments' do
      expect(pa.task_assignments.length).to eq(2)
    end
    it 'sets task assignment is_active' do
      expect(pa.task_assignments[0].is_active).to eq(true)
    end
    it 'sets task assignment id' do
      expect(pa.task_assignments[0].id).to eq(987_654_321)
    end
    it 'sets task assignment task id' do
      expect(pa.task_assignments[0].task.id).to eq(11_299_508)
    end
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
  let(:te) { factory.time_entry(time_entry_raw) }

  context 'when creating time entry struct' do
    it 'sets project name' do
      expect(te.project.name).to eq('Project Name')
    end
    it 'sets client name' do
      expect(te.client.name).to eq('Client Name')
    end
    it 'sets task name' do
      expect(te.task.name).to eq('Ops')
    end
    it 'sets task assignment id' do
      expect(te.task_assignment.id).to eq(175684707)
    end
    it 'sets external_reference service' do
      expect(te.external_reference.service).to eq('example.com')
    end
  end

  let(:blank_te) { factory.time_entry(nil) }

  context 'when creating blank time entry struct' do
    it 'sets id nil' do
      expect(blank_te.id.nil?).to eq(true)
    end
    it 'sets user.id nil' do
      expect(blank_te.user.id.nil?).to eq(true)
    end
    it 'sets user assignment id nil' do
      expect(blank_te.user_assignment.id.nil?).to eq(true)
    end
    it 'sets client id nil' do
      expect(blank_te.client.id.nil?).to eq(true)
    end
    it 'sets project id' do
      expect(blank_te.project.id.nil?).to eq(true)
    end
    it 'sets task id' do
      expect(blank_te.task.id.nil?).to eq(true)
    end
    it 'sets task assignment id' do
      expect(blank_te.task_assignment.id.nil?).to eq(true)
    end
    it 'sets external reference service' do
      expect(blank_te.external_reference.service.nil?).to eq(true)
    end
  end

  let(:blank_pa) { factory.project_assignment(nil) }
  context 'when creating blank project assignment struct' do
    it 'sets id nil' do
      expect(blank_pa.id.nil?).to eq(true)
    end
    it 'sets project id nil' do
      expect(blank_pa.project.id.nil?).to eq(true)
    end
    it 'sets client id nil' do
      expect(blank_pa.client.id.nil?).to eq(true)
    end
  end
end
