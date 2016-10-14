require 'spec_helper'

describe 'delete /badges/:owner/:project/:name' do
  before do
    Badge.all.destroy
    Badge.new(owner: 'jmccann', project: 'app1',
              name: 'coverage', created_at: DateTime.now).save
    Badge.new(owner: 'jmccann', project: 'app1',
              name: 'climate', created_at: DateTime.now).save
    Badge.new(owner: 'jmccann', project: 'app2',
              name: 'coverage', created_at: DateTime.now).save
    Badge.new(owner: 'jdoe', project: 'app1',
              name: 'coverage', created_at: DateTime.now).save
  end

  it 'should delete the Badge' do
    # Delete the ID
    delete '/badges/jmccann/app1/climate'
    expect(last_response.status).to eq 204

    # Make sure DB is 1 less
    expect(Badge.count).to eq 3
  end

  it 'should return error if deleting badge that does not exist' do
    delete '/badges/jmccann/app1/climate2'

    expect(last_response.status).to eq 500
    message = "No matching badge for 'jmccann/app1/climate2'"
    expect(JSON.parse(last_response.body)).to include('message' => message)
  end
end
