require 'spec_helper'

describe 'delete /badges/:owner/:project/:name' do
  it 'should delete the Badge' do
    # Delete the ID
    delete '/badges/jmccann/app1/climate'
    expect(last_response.status).to eq 204

    # Make sure DB is 1 less
    expect(Badge.count).to eq 4
  end

  it 'should return error if deleting badge that does not exist' do
    delete '/badges/jmccann/app1/climate2'

    expect(last_response.status).to eq 500
    message = 'No matching badge for jmccann/app1/climate2/master'
    expect(JSON.parse(last_response.body)).to include('message' => message)
  end
end

describe 'delete /badges/:owner/:project/:name/:branch' do
  it 'should delete the Badge' do
    # Delete the ID
    delete '/badges/jmccann/app1/climate/pr12'
    expect(last_response.status).to eq 204

    # Make sure DB is 1 less
    expect(Badge.count).to eq 4
  end

  it 'should return error if deleting badge that does not exist' do
    delete '/badges/jmccann/app1/climate2/pr12'

    expect(last_response.status).to eq 500
    message = 'No matching badge for jmccann/app1/climate2/pr12'
    expect(JSON.parse(last_response.body)).to include('message' => message)
  end

  it 'should return error if deleting badge branch that does not exist' do
    delete '/badges/jmccann/app1/climate/pr13'

    expect(last_response.status).to eq 500
    message = 'No matching badge for jmccann/app1/climate/pr13'
    expect(JSON.parse(last_response.body)).to include('message' => message)
  end
end
