require 'spec_helper'

describe 'get /badges' do
  it 'should list badges' do
    get '/badges'
    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body).count).to eq 4
  end

  it 'should list each badge by their full name' do
    get '/badges'
    expect(JSON.parse(last_response.body).first).to eq 'jmccann/app1/coverage'
  end
end

describe 'get /badges/:owner' do
  it 'should return all badges for an owner' do
    get '/badges/jmccann'

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body).count).to eq 3
  end
end

describe 'get /badges/:owner/:project/:name' do
  it 'should return 1 badge' do
    get '/badges/jmccann/app1/climate'

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to be_a Hash
  end

  it 'should return the badge details' do
    get '/badges/jmccann/app1/climate'

    expect(JSON.parse(last_response.body))
      .to include('id', 'created_at', 'full_name',
                  'owner' => 'jmccann', 'project' => 'app1',
                  'name' => 'climate')
  end
end
