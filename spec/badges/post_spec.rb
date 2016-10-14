require 'spec_helper'
require 'json'

describe 'post /ids/v1' do
  let(:headers) do
    { 'Content-Type' => 'application/json' }
  end

  before do
    Badge.all.destroy
  end

  it 'should insert the Badge' do
    post '/badges', {
      owner: 'jmccann',
      project: 'app1',
      name: 'test'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    follow_redirect!

    # Make sure we get back object details
    expect(JSON.parse(last_response.body))
      .to include('id', 'created_at',
                  'owner' => 'jmccann', 'project' => 'app1', 'name' => 'test',
                  'full_name' => 'jmccann/app1/test')

    # Make sure DB count increased by 1
    expect(Badge.count).to eq 1
  end

  it 'should error if missing owner' do
    post '/badges', {
      project: 'app1',
      name: 'test'
    }.to_json, headers

    expect(last_response.status).to eq 500
    message = 'Failed to create new Badge: Owner must not be blank'
    expect(JSON.parse(last_response.body)).to include('message' => message)
  end

  it 'should error if missing project' do
    post '/badges', {
      owner: 'jmccann',
      name: 'test'
    }.to_json, headers

    expect(last_response.status).to eq 500
    message = 'Failed to create new Badge: Project must not be blank'
    expect(JSON.parse(last_response.body)).to include('message' => message)
  end

  it 'should error if missing name' do
    post '/badges', {
      owner: 'jmccann',
      project: 'app1'
    }.to_json, headers

    expect(last_response.status).to eq 500
    message = 'Failed to create new Badge: Name must not be blank'
    expect(JSON.parse(last_response.body)).to include('message' => message)
  end
end
