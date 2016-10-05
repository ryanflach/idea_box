require 'rails_helper'

RSpec.describe 'Thumbs an idea' do
  scenario 'user uses thumbs up on an idea', js: true do
    Idea.create!(title: 'test', body: 'testing')

    expect(Idea.first.quality).to eq('swill')

    visit '/'

    within ('div #ideas #idea-1') do
      expect(page).to have_css('#up-1')
      expect(page).to_not have_css('#up-1[disabled]')
      expect(page).to have_css('#down-1[disabled]')
      expect(page).to have_content('swill')

      click_on 'Thumbs Up'

      expect(page).to_not have_content('swill')
      expect(page).to_not have_css('#down-1[disabled]')
      expect(page).to have_content('plausible')
      expect(Idea.first.quality).to eq('plausible')

      click_on 'Thumbs Up'

      expect(page).to_not have_content('plausible')
      expect(page).to have_content('genius')
      expect(page).to have_css('#up-1[disabled]')
      expect(Idea.first.quality).to eq('genius')
    end
  end

  scenario 'user uses thumbs down on an idea', js: true do
    Idea.create!(title: 'test', body: 'testing', quality: 'genius')

    expect(Idea.first.quality).to eq('genius')

    visit '/'

    within ('div #ideas #idea-1') do
      expect(page).to have_css('#down-1')
      expect(page).to have_css('#up-1[disabled]')
      expect(page).to_not have_css('#down-1[disabled]')
      expect(page).to have_content('genius')

      click_on 'Thumbs Down'

      expect(page).to_not have_content('genius')
      expect(page).to_not have_css('#up-1[disabled]')
      expect(page).to have_content('plausible')
      expect(Idea.first.quality).to eq('plausible')

      click_on 'Thumbs Down'

      expect(page).to_not have_content('plausible')
      expect(page).to have_content('swill')
      expect(page).to have_css('#down-1[disabled]')
      expect(Idea.first.quality).to eq('swill')
    end
  end

  scenario 'user uses thumbs up and down on an idea', js: true do
    Idea.create!(title: 'test', body: 'testing', quality: 'plausible')

    expect(Idea.first.quality).to eq('plausible')

    visit '/'

    within ('div #ideas #idea-1') do
      expect(page).to have_css('#down-1')
      expect(page).to have_css('#up-1')
      expect(page).to_not have_css('#down-1[disabled]')
      expect(page).to_not have_css('#up-1[disabled]')
      expect(page).to have_content('plausible')

      click_on 'Thumbs Down'

      expect(page).to_not have_content('plausible')
      expect(page).to have_css('#down-1[disabled]')
      expect(page).to have_content('swill')
      expect(Idea.first.quality).to eq('swill')

      click_on 'Thumbs Up'

      expect(page).to_not have_content('swill')
      expect(page).to have_content('plausible')
      expect(page).to_not have_css('#down-1[disabled]')
      expect(Idea.first.quality).to eq('plausible')
    end
  end
end
