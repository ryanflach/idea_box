require 'rails_helper'

RSpec.describe 'Request destroy idea' do
  it 'destroys an idea' do
    idea = create(:idea)

    expect(Idea.count).to eq(1)

    delete "/api/v1/ideas/#{idea.id}"

    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(Idea.count).to eq(0)
  end
end
