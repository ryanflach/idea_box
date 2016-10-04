require 'rails_helper'

RSpec.describe 'Delete an idea' do
  scenario 'user deletes an existing idea', js: true do
    Idea.create!(title: 'Hello', body: 'yoyo')

    visit '/'

    within('div #ideas #idea-1') do
      expect(page).to have_content('Hello')
      expect(page).to have_content('yoyo')
      click_on 'Delete'
    end

    expect(Idea.count).to eq(0)

    expect(page).to_not have_css('#idea-1')
    expect(page).to_not have_content('Hello')
    expect(page).to_not have_content('yoyo')
  end
end
