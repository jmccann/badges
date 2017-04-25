require 'spec_helper'

describe 'put /badges/:owner/:project/:name' do
  let(:headers) do
    { 'Content-Type' => 'application/json' }
  end

  it 'updates the badge' do
    badge = Badge.all(owner: 'jmccann', project: 'app1', name: 'climate').first
    expect(badge.image).to match(/>97%</)

    put '/badges/jmccann/app1/climate', {
      color: 'red',
      status: '27%25'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    follow_redirect!

    expect(JSON.parse(last_response.body)['image']).not_to match(/>97%</)
    expect(JSON.parse(last_response.body)['image']).to match(/>27%</)
    badge = Badge.all(owner: 'jmccann', project: 'app1', name: 'climate').first
    expect(badge.image).to match(/>27%</)
  end

  it 'updates the badge with integer status' do
    badge = Badge.all(owner: 'jmccann', project: 'app1', name: 'climate').first
    expect(badge.image).to match(/>97%</)

    put '/badges/jmccann/app1/climate', {
      color: 'red',
      status: '27'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    follow_redirect!

    expect(JSON.parse(last_response.body)['image']).not_to match(/>97%</)
    expect(JSON.parse(last_response.body)['image']).to match(/>27</)
    badge = Badge.all(owner: 'jmccann', project: 'app1', name: 'climate').first
    expect(badge.image).to match(/>27</)
  end

  it 'returns updated details of the badge' do
    put '/badges/jmccann/app1/climate', {
      color: 'red',
      status: '27%25'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    expect(last_response).to be_redirect
    follow_redirect!

    expect(JSON.parse(last_response.body))
      .to include('id', 'created_at', 'full_name',
                  'owner' => 'jmccann', 'project' => 'app1',
                  'name' => 'climate')
  end

  it 'updates the badge for a branch' do
    badge = Badge.all(owner: 'jmccann', project: 'app1', name: 'climate').first
    expect(badge.image).to match(/>97%</)

    put '/badges/jmccann/app1/climate/pr12', {
      color: 'red',
      status: '29%25'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    follow_redirect!

    expect(JSON.parse(last_response.body)['image']).not_to match(/>97%</)
    expect(JSON.parse(last_response.body)['image']).to match(/>29%</)
    badge = Badge.all(owner: 'jmccann', project: 'app1', name: 'climate',
                      branch: 'pr12').first
    expect(badge.image).to match(/>29%</)
  end

  it 'returns updated details of the badge for a branch' do
    put '/badges/jmccann/app1/climate/pr12', {
      color: 'red',
      status: '29%25'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    expect(last_response).to be_redirect
    follow_redirect!

    expect(JSON.parse(last_response.body))
      .to include('id', 'created_at',
                  'full_name' => 'jmccann/app1/climate',
                  'owner' => 'jmccann', 'project' => 'app1',
                  'name' => 'climate', 'branch' => 'pr12')
  end

  it 'creates badge if it doesn not exist' do
    expect(Badge.count).to eq 5
    expect(Badge).to receive(:new).and_call_original

    put '/badges/jmccann/app1/test', {
      color: 'green',
      status: '97%25'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    follow_redirect!

    # Make sure we get back object details
    expect(JSON.parse(last_response.body))
      .to include('id', 'created_at', 'image',
                  'owner' => 'jmccann', 'project' => 'app1', 'name' => 'test',
                  'full_name' => 'jmccann/app1/test')

    # Make sure DB count increased by 1
    expect(Badge.count).to eq 6
  end

  it 'creates badge for branch if it doesn not exist' do
    expect(Badge.count).to eq 5
    expect(Badge).to receive(:new).and_call_original

    put '/badges/jmccann/app1/test/pr11', {
      color: 'green',
      status: '97%25'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    follow_redirect!

    # Make sure we get back object details
    expect(JSON.parse(last_response.body))
      .to include('id', 'created_at', 'image',
                  'owner' => 'jmccann', 'project' => 'app1', 'name' => 'test',
                  'full_name' => 'jmccann/app1/test', 'branch' => 'pr11')

    # Make sure DB count increased by 1
    expect(Badge.count).to eq 6
  end
end
