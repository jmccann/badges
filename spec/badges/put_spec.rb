require 'spec_helper'

describe 'put /badges/:owner/:project/:name' do
  let(:headers) do
    { 'Content-Type' => 'application/json' }
  end

  let(:open_return) do
    StringIO.new svg_27
  end

  before do
    allow(OpenURI).to receive(:open_uri).and_return open_return
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

  it 'returns updated details of the badge' do
    put '/badges/jmccann/app1/climate', {
      color: 'red',
      status: '27%25'
    }.to_json, headers

    # Make sure we are redirecting
    expect(last_response.status).to eq 302
    follow_redirect!

    expect(JSON.parse(last_response.body))
      .to include('id', 'created_at', 'full_name',
                  'owner' => 'jmccann', 'project' => 'app1',
                  'name' => 'climate')
  end
end
