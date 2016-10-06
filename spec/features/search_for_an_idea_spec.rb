require 'rails_helper'

RSpec.describe 'Search for an idea' do
  context 'no ideas present' do
    scenario 'search not visible without ideas', js: true do
      visit '/'

      expect(page).to_not have_content('Search')
      expect(page).to have_css('#idea-search-box', visible: false)
    end
  end

  context 'with ideas present' do
    scenario 'when ideas search bar is visible', js: true do
      create(:idea)

      visit '/'

      expect(page).to have_content('Search')
      expect(page).to have_css('#idea-search-box', visible: true)
    end

    scenario 'user filters existing ideas by searching', js: true do
      unique_idea = create(:idea, title: 'Unique', body: 'example text')
      generic_idea =
        create(:idea, title: 'Generic', body: 'example text')

      visit '/'

      fill_in 'search-box', with: 'unique'

      within('div #ideas') do
        expect(page).to have_content('Unique')
        expect(page).to_not have_content('Generic')
      end

      fill_in 'search-box', with: 'not present'

      within('div #ideas') do
        expect(page).to_not have_content('Unique')
        expect(page).to_not have_content('Generic')
        expect(page).to_not have_content('example text')
      end

      fill_in 'search-box', with: 'Example text'

      within('div #ideas') do
        expect(page).to have_content('Unique')
        expect(page).to have_content('Generic')
        expect(page).to have_content('example text')
      end
    end

    scenario 'user filters new ideas by searching', js: true do
      visit '/'

      fill_in 'idea-title', with: 'Hello'
      fill_in 'idea-body', with: 'Great idea'
      click_on 'Create Idea'

      fill_in 'search-box', with: 'hello'

      within('div #ideas') do
        expect(page).to have_content('Hello')
        expect(page).to have_content('Great idea')
      end

      fill_in 'search-box', with: 'not present'

      within('div #ideas') do
        expect(page).to_not have_content('Hello')
        expect(page).to_not have_content('Great idea')
      end

      fill_in 'search-box', with: 'great'

      within('div #ideas') do
        expect(page).to have_content('Hello')
        expect(page).to have_content('Great idea')
      end
    end
  end
end
