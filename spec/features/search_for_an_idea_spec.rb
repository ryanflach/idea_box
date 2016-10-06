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

    scenario 'user filters ideas by searching', js: true do
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
  end
end
