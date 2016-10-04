require 'rails_helper'

RSpec.describe 'Create an idea' do
  scenario 'user adds the only idea', js: true do
    expect(Idea.count).to eq(0)

    visit '/'

    expect(page).to_not have_content('Hello')
    expect(page).to_not have_content('Howdy')
    expect(page).to_not have_css('#idea-1')

    fill_in 'idea-title', with: 'Hello'
    fill_in 'idea-body', with: 'Howdy'
    click_on 'Create Idea'

    within('div #ideas') do
      expect(page).to have_css('#idea-1')
      expect(page).to have_content('Hello')
      expect(page).to have_content('Howdy')
    end

    expect(Idea.count).to eq(1)
    expect(page).to have_field('idea-title', with: '')
    expect(page).to have_field('idea-body', with: '')
    expect(page).to_not have_field('idea-title', with: 'Hello')
    expect(page).to_not have_field('idea-body', with: 'Howdy')
  end

  scenario 'user adds an additional idea', js: true do
    Idea.create!(title: 'No!', body: 'Yes!')
    expect(Idea.count).to eq(1)

    visit '/'

    within('div #ideas') do
      expect(page).to have_css('#idea-1')
      expect(page).to have_content('No!')
      expect(page).to have_content('Yes!')
    end

    fill_in 'idea-title', with: 'Hello'
    fill_in 'idea-body', with: 'Howdy'
    click_on 'Create Idea'

    expect(Idea.count).to eq(2)

    within('div #ideas') do
      expect(page).to have_css('#idea-2')
      expect(page).to have_content('Hello')
      expect(page).to have_content('Howdy')
      expect(page).to have_css('#idea-1')
      expect(page).to have_content('No!')
      expect(page).to have_content('Yes!')
    end
  end
end
