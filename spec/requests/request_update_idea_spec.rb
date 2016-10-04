require 'rails_helper'

RSpec.describe 'Request update idea' do
  context 'via put request' do
    it 'updates an existing idea' do
      idea = Idea.create!(title: 'Idea!', body: 'hello')

      expect(Idea.count).to eq(1)
      expect(Idea.first.title).to eq('Idea!')
      expect(Idea.first.body).to_not eq('cool')
      expect(Idea.first.quality).to eq('swill')

      put "/api/v1/ideas/#{idea.id}?title=Ok&body=cool&quality=genius"

      updated_idea = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(Idea.count).to eq(1)
      expect(updated_idea['title']).to eq('Ok')
      expect(updated_idea['body']).to eq('cool')
      expect(updated_idea['quality']).to eq('genius')
      expect(Idea.first.title).to eq(updated_idea['title'])
      expect(Idea.first.body).to eq(updated_idea['body'])
      expect(Idea.first.quality).to eq(updated_idea['quality'])
      expect(updated_idea).to have_key('id')
      expect(updated_idea).to_not have_key('created_at')
      expect(updated_idea).to_not have_key('updated_at')
    end
  end

  context 'via patch request' do
    it 'updates an existing idea' do
      idea = Idea.create!(title: 'Idea!', body: 'hello')

      expect(Idea.count).to eq(1)
      expect(Idea.first.title).to eq('Idea!')
      expect(Idea.first.body).to_not eq('cool')
      expect(Idea.first.quality).to eq('swill')

      patch "/api/v1/ideas/#{idea.id}?title=Ok&body=cool&quality=genius"

      updated_idea = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(Idea.count).to eq(1)
      expect(updated_idea['title']).to eq('Ok')
      expect(updated_idea['body']).to eq('cool')
      expect(updated_idea['quality']).to eq('genius')
      expect(Idea.first.title).to eq(updated_idea['title'])
      expect(Idea.first.body).to eq(updated_idea['body'])
      expect(Idea.first.quality).to eq(updated_idea['quality'])
      expect(updated_idea).to have_key('id')
      expect(updated_idea).to_not have_key('created_at')
      expect(updated_idea).to_not have_key('updated_at')
    end
  end
end
