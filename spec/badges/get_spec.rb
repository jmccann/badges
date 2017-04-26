require 'spec_helper'

describe 'get /badges' do
  it 'should list badges' do
    get '/badges'
    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body).count).to eq 5
  end

  it 'should list each badge by their full name' do
    get '/badges'
    expect(JSON.parse(last_response.body)).to include('jmccann/app1/coverage')
  end
end

describe 'get /badges/:owner' do
  it 'should return all badges for an owner' do
    get '/badges/jmccann'

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body).count).to eq 4
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
      .to include('created_at', 'full_name',
                  'owner' => 'jmccann', 'project' => 'app1',
                  'name' => 'climate')
  end
end

describe 'get /badges/:owner/:project/:name/badge.svg' do
  it 'should return 1 badge' do
    get '/badges/jmccann/app1/climate/badge.svg'

    expect(last_response).to be_ok
    expect(last_response.body).to be_a String
  end

  it 'should return with svg content_type' do
    get '/badges/jmccann/app1/climate/badge.svg'

    expect(last_response).to be_ok
    expect(last_response.content_type).to eq 'image/svg+xml'
  end

  it 'should return the badge details' do
    get '/badges/jmccann/app1/climate/badge.svg'

    expect(last_response.body).to match(/<svg/)
  end
end

describe 'get /badges/:owner/:project/:name/:branch' do
  it 'should return 1 badge' do
    get '/badges/jmccann/app1/climate/pr12'

    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)).to be_a Hash
  end

  it 'should return the badge details' do
    get '/badges/jmccann/app1/climate/pr12'

    expect(JSON.parse(last_response.body))
      .to include('created_at', 'full_name',
                  'owner' => 'jmccann', 'project' => 'app1',
                  'name' => 'climate', 'branch' => 'pr12')
  end
end

describe 'get /badges/:owner/:project/:name/:branch/badge.svg' do
  it 'should return 1 badge' do
    get '/badges/jmccann/app1/climate/pr12/badge.svg'

    expect(last_response).to be_ok
    expect(last_response.body).to be_a String
  end

  it 'should return with svg content_type' do
    get '/badges/jmccann/app1/climate/pr12/badge.svg'

    expect(last_response).to be_ok
    expect(last_response.content_type).to eq 'image/svg+xml'
  end

  it 'should return the badge details' do
    get '/badges/jmccann/app1/climate/badge.svg'

    expect(last_response.body).to match(/<svg/)
  end
end
