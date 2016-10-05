require 'rails_helper'

RSpec.describe 'Edit an idea' do
  scenario 'user edits an existing idea title', js: true do
    Idea.create!(title: 'hello', body: 'is a cage')

    visit '/'

    within ('div #ideas #idea-1') do
      expect(page).to have_content('hello')
      expect(page).to have_content('is a cage')

      element = find('#title')
      5.times { element.native.send_keys(:delete) }
      element.set('goodbye')
      element.native.send_keys(:return)

      expect(page).to have_content('goodbye')
      expect(page).to have_content('is a cage')
      expect(page).to_not have_content('hello')
    end

    expect(Idea.first.title).to eq('goodbye')
    expect(Idea.first.body).to eq('is a cage')
  end

  scenario 'user edits an existing idea body', js: true do
    Idea.create!(title: 'hello', body: 'is a cage')

    visit '/'

    within ('div #ideas #idea-1') do
      expect(page).to have_content('hello')
      expect(page).to have_content('is a cage')

      element = find('#body')
      9.times { element.native.send_keys(:delete) }
      element.set('is most definitely not a cage')
      element.native.send_keys(:return)

      expect(page).to have_content('hello')
      expect(page).to_not have_content('is a cage')
      expect(page).to have_content('is most definitely not a cage')
    end

    expect(Idea.first.title).to eq('hello')
    expect(Idea.first.body).to eq('is most definitely not a cage')
  end

  scenario 'user edits an existing idea title and body', js: true do
    Idea.create!(title: 'hello', body: 'is a cage')

    visit '/'

    within ('div #ideas #idea-1') do
      expect(page).to have_content('hello')
      expect(page).to have_content('is a cage')

      title_element = find('#title')
      5.times { title_element.native.send_keys(:delete) }
      title_element.set('goodbye')
      title_element.native.send_keys(:return)

      body_element = find('#body')
      9.times { body_element.native.send_keys(:delete) }
      body_element.set('is most definitely not a cage')
      body_element.native.send_keys(:return)

      expect(page).to_not have_content('hello')
      expect(page).to_not have_content('is a cage')
      expect(page).to have_content('goodbye')
      expect(page).to have_content('is most definitely not a cage')
    end

    expect(Idea.first.title).to eq('goodbye')
    expect(Idea.first.body).to eq('is most definitely not a cage')
  end
end
