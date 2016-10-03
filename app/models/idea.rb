class Idea < ApplicationRecord
  validates_presence_of :title

  enum quality: ['swill', 'plausible', 'genius']
end
