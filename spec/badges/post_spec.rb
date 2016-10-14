require 'spec_helper'
require 'json'

describe 'post /badges/:owner/:project/:name' do
  let(:headers) do
    { 'Content-Type' => 'application/json' }
  end

  before do
    Badge.all.destroy
  end

  it 'should insert the Badge' do
    post '/badges/jmccann/app1/test'

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
end