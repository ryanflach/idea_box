require 'rails_helper'

RSpec.describe 'Request create idea' do
  it 'creates an idea' do
    expect(Idea.count).to eq(0)

    post '/api/v1/ideas?title=my idea&body=a great idea'

    created_idea = JSON.parse(response.body)

    expect(response).to have_http_status(201)
    expect(response.content_type).to eq('application/json')
    expect(Idea.count).to eq(1)
    expect(created_idea).to_not have_key('id')
    expect(created_idea).to_not have_key('created_at')
    expect(created_idea).to_not have_key('updated_at')
    expect(created_idea['title']).to eq('my idea')
    expect(created_idea['body']).to eq('a great idea')
    expect(created_idea['quality']).to eq('swill')
  end
end
