require 'rails_helper'

RSpec.describe 'Request ideas', type: :request do
  it 'gets all ideas' do
    first_idea = create(:idea, title: 'Great idea!')
    second_idea = create(:idea)

    expect(Idea.count).to eq(2)
    expect(Idea.first.title).to eq('Great idea!')
    expect(Idea.second.title).to eq('Idea!')

    get '/api/v1/ideas'

    ideas = JSON.parse(response.body)

    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(ideas.count).to eq(2)
    expect(ideas.first).to have_key('title')
    expect(ideas.first).to have_key('body')
    expect(ideas.first).to have_key('quality')
    expect(ideas.first).to_not have_key('id')
    expect(ideas.first).to_not have_key('created_at')
    expect(ideas.first).to_not have_key('updated_at')
    expect(ideas.first['title']).to eq('Great idea!')
    expect(ideas.second['title']).to eq('Idea!')
  end
end
